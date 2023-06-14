# Project Templating Docker Trivial Example

The smallest possible example that shows the usage of the projet templating feature.
This isn't intended to simulate real production use. Rather, it should be
used as a jumping-off point to craft a more fully-featured
project template.

Steps:

Terraform Cloud and Github Setup
- Create a TFC org with enterprise permissions
- Fork https://github.com/hashicorp/terraform-null-waypoint-template-trivial
- Create a no-code module using the forked repo
- Create a TFC Token

Waypoint
- Create a new HCP project
- Activate waypoint
- Configure a new local waypoint context
- Start a local runner agent
- Configure Terraform settings
- Create a new project  template using the below inputs:

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
Congrats on bootstrapping "{{.ProjectName}}"!

Just run `waypoint up`!
```

- Create a new project from the template
- Connect the new project to a git repo
- Run `waypoint up` locally!