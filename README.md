# dokku-deploy-github-action

This repo is based on Ido Berkovich's [repo](https://github.com/idoberko2/dokku-deploy-github-action). It has been modified to use Git Subtree to deploy a separate build folder to dokku.

## Usage

Code example

```yaml
- id: deploy
name: Deploy to dokku
uses: slinden2/dokku-deploy-github-action@v1
with:
    ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}
    dokku-ip-address: ${{ secrets.SERVER_IP }}
    dokku-host: 'player.fan'
    app-name: 'playerfan'
    git-subtree-prefix: 'web'
```

Available parameters:

- ssh-private-key | required
- dokku-user | User for dokku. Optional. Default: dokku
- dokku-host | Domain name of the server. Required.
- dokku-ip-address | Needed if the domain name doesn't point directly to the server (for example with CloudFlare). Optional.
- app-name | Name of the application. Required.
- remote-branch | Name of the branch to be pushed. Optional. Default: master
- git-push-flags | Flags to be used with git subtree. Optional.
- git-subtree-prefix | Name of the directory to push (where the built application is)
