# Custom Account Hierarchy

<a href="https://githubsfdeploy.herokuapp.com?owner=effordDev&repo=sf-custom-account-hierarchy">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

<img src="https://raw.githubusercontent.com/effordDev/sf-custom-account-hierarchy/master/2023-01-13-13-08-05.png"/>

## Deploy

Clone repo
```bash
git clone https://github.com/effordDev/sf-custom-account-hierarchy
```

Covert with SFDX; This creates a folder called `deploy`

```bash
sfdx force:source:convert -r force-app -d deploy
```

Now you can deploy from the resulting `deploy` directory

📌  Below deploys to the default org set

- Add `-u user@domain.com` or `-u alias` to deploy else where

```bash
sfdx force:mdapi:deploy -d deploy -w -1 --verbose
```
