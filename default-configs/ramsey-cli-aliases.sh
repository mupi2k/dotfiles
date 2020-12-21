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
fi

