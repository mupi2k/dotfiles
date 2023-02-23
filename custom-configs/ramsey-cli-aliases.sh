
if [ -n $USE_RAMSEY ]; then

        alias rct="ramsey console --profile admin/core-test --container"
        alias kwt="ramsey kw --profile admin/core-test --"
        alias rcq="ramsey console --profile admin/core-qa --container"
        alias kwq="ramsey kw --profile admin/core-qa --"
        alias rcp="ramsey console --profile admin/core-prod --container"
        alias kwp="ramsey kw --profile admin/core-prod --"
        alias rcc="ramsey console --profile admin/cicd --container"
        alias kwc="ramsey kw --profile admin/cicd --"
        alias rci="ramsey console --profile admin/iam --container"
        alias kwi="ramsey kw --profile admin/iam --"
        alias rcdt="ramsey console --profile admin/debit-test --container"
        alias kwdt="ramsey kw --profile admin/debit-test --"
        alias rcdq="ramsey console --profile admin/debit-qa --container"
        alias kwdq="ramsey kw --profile admin/debit-qa --"
        alias rcdp="ramsey console --profile admin/debit-prod --container"
        alias kwdp="ramsey kw --profile admin/debit-prod --"
        alias rcfps="ramsey console --profile admin/financial-peace-sandbox --container"
        alias kwfps="ramsey kw --profile admin/financial-peace-sandbox --"
        alias rcta1="ramsey console --profile admin/tech-assessment-1 --container"
        alias kwta1="ramsey kw --profile admin/tech-assessment-1 --"
        alias rcta2="ramsey console --profile admin/tech-assessment-2 --container"
        alias kwta2="ramsey kw --profile admin/tech-assessment-2 --"
        alias rcbott="ramsey console --profile admin/business-operations-technology-test --container"
        alias kwbott="ramsey kw --profile admin/business-operations-technology-test --"
        alias rcbotq="ramsey console --profile admin/business-operations-technology-qa --container"
        alias kwbotq="ramsey kw --profile admin/business-operations-technology-qa --"
        alias rcbotp="ramsey console --profile admin/business-operations-technology-prod --container"
        alias kwbotp="ramsey kw --profile admin/business-operations-technology-prod --"
        alias rce="ramsey console --profile admin/events --container"
        alias kwe="ramsey kw --profile admin/events --"
        alias rcfws="ramsey console --profile admin/financial-wellness-sandbox --container"
        alias kwfws="ramsey kw --profile admin/financial-wellness-sandbox --"
fi

if [ -n $WS_CLI ]; then
  source $WS_CLI/bash-functions.sh
fi

export PULUMI_TEMPLATES=${HOME}/rs/rs-pulumi-templates
export MIGRATION_TOOLS=${HOME}/rs/ws-bunkbed-migration-tools
