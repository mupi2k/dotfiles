# Find account id by account name or account name by account id
acc() {
  if [ -z "$1" ]; then
    jq -r ".accountList | sort_by(.accountName)[] | [.accountId,.accountName] |  @tsv" ~/.aws/sso_accounts.json;
  else
    if [[ "$1" =~ ^[0-9]+$ ]]; then
      matched_account=$(jq -r ".accountList | sort_by(.accountName)[] | [.accountId,.accountName] | @tsv" ~/.aws/sso_accounts.json | grep $1 )
      if [ -n "$matched_account" ]; then
        echo -n "$matched_account" | awk '{print $2}' | tr -d '\n' | pbcopy
        account_name=$(echo -n "$matched_account" | awk '{print $2}' | tr -d '\n')
        account_id=$(echo -n "$matched_account" | awk '{print $1}' | tr -d '\n')
        echo -e "Copied: $account_name \e[90m($account_id)\e[0m"
      else
        echo "No account found with the provided account ID: $1"
      fi
    else
      # Create an awk pattern for fuzzy finding based on multiple args
      construct_awk_pattern() {
        local result=""
        for arg in "$@"; do
          result="${result}/$arg/ && "
        done
        # Remove the trailing " && " from the result
        result="${result% && }"
        echo "$result"
      }
      awk_pattern=$(construct_awk_pattern "$@")
      matched_accounts=$(jq -r ".accountList | sort_by(.accountName)[] | [.accountId,.accountName] | @tsv" ~/.aws/sso_accounts.json | awk "$awk_pattern")
      if [ -n "$matched_accounts" ]; then
        num_accounts_found=$(echo "$matched_accounts" | wc -l)
        if [ "$num_accounts_found" -gt 1 ]; then
          echo "Found multiple accounts that match your query:"
          echo $matched_accounts
        else
          account_name=$(echo -n "$matched_accounts" | awk '{print $2}')
          account_id=$(echo -n "$matched_accounts" | awk '{print $1}')
          echo -n "$matched_accounts" | awk '{print $1}' | tr -d '\n' | pbcopy
          echo -e "Copied: $account_id \e[90m($account_name)\e[0m"
        fi
      else
        echo "No accounts found matching: $@"
      fi
    fi
  fi
}

