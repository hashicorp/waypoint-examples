# Project Templating Docker Trivial Example

The smallest possible example that shows the usage of the projet templating feature.
This isn't intended to simulate real production use. Rather, it should be
used as a jumping-off point to craft a more fully-featured
project template.



### Inputs

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