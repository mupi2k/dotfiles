echo "loading from default-configs ... "
if [ -n $USE_RAMSEY ]; then

        alias rct="ramsey console --profile power/core-test"
        alias kwt="ramsey kw --profile power/core-test --"
        alias rcq="ramsey console --profile power/core-qa"
        alias kwq="ramsey kw --profile power/core-qa --"
        alias rcp="ramsey console --profile power/core-prod"
        alias kwp="ramsey kw --profile power/core-prod --"
        alias rcc="ramsey console --profile power/cicd"
        alias kwc="ramsey kw --profile power/cicd --"
        alias rci="ramsey console --profile power/iam"
        alias kwi="ramsey kw --profile power/iam --"
        alias rcdt="ramsey console --profile power/debit-test"
        alias kwdt="ramsey kw --profile power/debit-test --"
        alias rcdq="ramsey console --profile power/debit-qa"
        alias kwdq="ramsey kw --profile power/debit-qa --"
        alias rcdp="ramsey console --profile power/debit-prod"
        alias kwdp="ramsey kw --profile power/debit-prod --"
        alias rcfps="ramsey console --profile power/financial-peace-sandbox"
        alias kwfps="ramsey kw --profile power/financial-peace-sandbox --"
        alias rcta1="ramsey console --profile power/tech-assessment-1"
        alias kwta1="ramsey kw --profile power/tech-assessment-1 --"
        alias rcta2="ramsey console --profile power/tech-assessment-2"
        alias kwta2="ramsey kw --profile power/tech-assessment-2 --"
        alias rcbott="ramsey console --profile power/business-operations-technology-test"
        alias kwbott="ramsey kw --profile power/business-operations-technology-test --"
        alias rcbotq="ramsey console --profile power/business-operations-technology-qa"
        alias kwbotq="ramsey kw --profile power/business-operations-technology-qa --"
        alias rcbotp="ramsey console --profile power/business-operations-technology-prod"
        alias kwbotp="ramsey kw --profile power/business-operations-technology-prod --"
        alias rce="ramsey console --profile power/events"
        alias kwe="ramsey kw --profile power/events --"
        alias rcfws="ramsey console --profile power/financial-wellness-sandbox"
        alias kwfws="ramsey kw --profile power/financial-wellness-sandbox --"

        # AWS/CodeArtifact/ECR config — Ramsey-specific values, candidates for
        # generalization once login() is decoupled from a single AWS profile
        export CA_DOMAIN="ramsey-solutions"
        export CA_DOMAIN_OWNER="058238361356"
        export CA_REGION="us-east-1"
        export CA_TOKEN_DURATION=43200
        export ECR_REGION="us-east-1"
        export ECR_ACCOUNTS=("674907502808" "058238361356")

        function login {
          local token_json token_err
          if ! aws sts get-caller-identity --profile core-test --no-cli-pager &> /dev/null; then
            echo "Not logged in to AWS, starting SSO flow..."
            source assume core-test
            if [ $? -ne 0 ]; then
              echo "[ERROR] Failed to authenticate with AWS" >&2
              return 1
            fi
          else
            echo "Already logged in to AWS"
          fi
          token_err=$(mktemp)
          token_json=$(aws codeartifact get-authorization-token \
            --profile core-test \
            --domain "$CA_DOMAIN" \
            --domain-owner "$CA_DOMAIN_OWNER" \
            --region "$CA_REGION" \
            --duration-seconds "$CA_TOKEN_DURATION" \
            --no-cli-pager 2>|"$token_err")
          local token
          token=$(echo "$token_json" | jq -r '.authorizationToken // empty')
          if [ -z "$token" ]; then
            echo "[ERROR] Failed to get CodeArtifact token." >&2
            [ -s "$token_err" ] && echo "  AWS error: $(cat "$token_err")" >&2
            rm -f "$token_err"
            return 1
          fi
          rm -f "$token_err"
          export CODEARTIFACT_AUTH_TOKEN="$token"
          echo "  CodeArtifact token refreshed (expires in ~12h)"
          if command -v docker &> /dev/null; then
            local ecr_password ecr_err
            ecr_err=$(mktemp)
            if ecr_password=$(aws ecr get-login-password --profile core-test --region "$ECR_REGION" --no-cli-pager 2>|"$ecr_err"); then
              rm -f "$ecr_err"
              for account in "${ECR_ACCOUNTS[@]}"; do
                echo "$ecr_password" | docker login --username AWS --password-stdin "${account}.dkr.ecr.${ECR_REGION}.amazonaws.com" 2> /dev/null
              done
              echo "  ECR: configured"
            else
              echo "[WARN] Failed to get ECR login password" >&2
              [ -s "$ecr_err" ] && echo "  AWS error: $(cat "$ecr_err")" >&2
              rm -f "$ecr_err"
            fi
          fi
        }

        function pl {
          if ! [ -z $1 ]; then
            source assume $1
          fi
          AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
          PULUMI_BACKEND_URL="s3://rs-pulumi-state-$AWS_ACCOUNT_ID"
          matched_account=$(jq -r ".accountList | sort_by(.accountName)[] | [.accountId,.accountName] | @tsv" ~/.aws/sso_accounts.json | grep $AWS_ACCOUNT_ID | awk '{print $2}')
          echo "setting PULUMI_BACKEND_URL to $PULUMI_BACKEND_URL \e[90m($matched_account)\e[0m"
          export PULUMI_BACKEND_URL=$PULUMI_BACKEND_URL
        }

        precmd () { __get_aws_account > /dev/null }
fi

