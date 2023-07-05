# Project Templating Docker Starter Example

The smallest possible example that shows the usage of the project templating feature.
This isn't intended to simulate real production use. Rather, it should be
used as a jumping-off point to craft a more fully-featured
project template.

**For setup instructions, see this walkthrough video: https://drive.google.com/file/d/1cyQYae7LFyRnDINFZiWad6sOacJU1saw/view?usp=sharing

## Video outline with code snippets:

### Platform Engineer Workflow

Terraform Module
- Create a new git repo called `terraform-null-waypoint-template-starter`
- Copy everything from `[./terraform-null-waypoint-template-starter](./terraform-null-waypoint-template-starter) to your new repo
- Commit and push your changes
- Create and push a tag (e.g. `git tag v0.0.1; git push --tags`)

Terraform Cloud
- Log into your enterprise-tier Terraform Cloud organization
- Publish a new [private registry](https://developer.hashicorp.com/terraform/cloud-docs/registry) module
- Connect your module to your `terraform-null-waypoint-template-starter` git repo
- Add your module the [no-code](https://developer.hashicorp.com/terraform/cloud-docs/no-code-provisioning/module-design) provision allowlist
- Create an API token, and save this for the next step

HCP Waypoint
- Create a new HCP project
- Activate waypoint
- [Install waypoint locally]([url](https://developer.hashicorp.com/waypoint/tutorials/get-started-docker/get-started-install)) 
- Configure a new local waypoint context by clicking Manage -> Connect to Waypoint in the CLI
- Start a local runner agent by running `waypoint runner agent`
- Create a new project template using the below inputs:
- Click "Settings" and add your TFC organization name and token

waypoint.hcl
```hcl
project = "{{.ProjectName}}"

app "{{.ProjectName}}" {
  build {
    use "docker" {
    }
  }

  deploy {
    use "docker" {
    }
  }
}
```

readme markdown
```markdown
App developer: congradulatons on bootstrapping "{{.ProjectName}}"!

Your next steps:
- Write some computer code! Make sure it responds on port 3000, and push it to github
- Connect that github repo to waypoint by visiting the `Settings` page
- Create a new CLI context by clicking `Manage`
- Run `waypoint up -p {{.ProjectName}}`, and your changes will be deployed to production!

From here on, you can continue to make and push changes, and run `waypoint up -p {{.ProjectName}}` to deploy them.

Your friend,
The Platform Engineer
```

### App Developer Workflow
- Create a new project from the template
- Follow the instructions from the platform engineer
