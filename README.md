# lkl-docker

### Instruction to update images

The workflow to deploy docker images is:

- make changes to master branch, or merge a pull request to master branch
- (manually) tag to the commit on the master branch

This tag will trigger an autobuild on circleci and upload images to docker hub.
Pull requests only trigger build without the deployment.
