# Wavestone 2

Un projet Terraform pour déployer une infrastructure 3 tiers sur AWS

## Développement

Pour travailler en local, vous avez besoin d'une clé d'accès AWS. Rendez-vous sur [ce lien](https://console.aws.amazon.com/iam/home?region=eu-west-3#/security_credentials) et cliquez sur "Create access key" pour la créer. Notez ensuite la "Key ID" et la "Secret access key" dans un fichier appelé `.env` contenant ceci :
```shell
export AWS_ACCESS_KEY_ID=<la key ID>
export AWS_SECRET_ACCESS_KEY=<la secret access key>
```

Avant d'exécuter les commandes Terraform vous devez `source .env` pour charger les clés d'accès en mémoire.

Avant le premier lancement vous devez faire `terraform init` pour initialiser le projet et télécharger les plugins nécessaires.

Note : ces instructions ne fonctionnent que sous Linux ou MacOS.
