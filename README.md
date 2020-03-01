# Wavestone 2

Un projet Terraform pour déployer une infrastructure 3 tiers sur AWS

## Développement

Pour travailler en local, vous avez besoin d'une clé d'accès AWS. Rendez-vous sur [ce lien](https://console.aws.amazon.com/iam/home?region=eu-west-3#/security_credentials) et cliquez sur "Create access key" pour la créer. Notez ensuite la "Key ID" et la "Secret access key" dans un fichier appelé `.env` contenant ceci :
```shell
export AWS_ACCESS_KEY_ID=<la key ID>
export AWS_SECRET_ACCESS_KEY=<la secret access key>
```

Avant d'exécuter les commandes Terraform vous devez `source .env` pour charger les clés d'accès en mémoire.


Note : ces instructions ne fonctionnent que sous Linux ou MacOS.

Pour générer la clé SSH nécessaire au provisionning des VMs, lancez la commande suivante `ssh-keygen -f terraform_key` et appuyez sur <kbd>Entrée</kbd> pour ne pas configurer de passphrase.
