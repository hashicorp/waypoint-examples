project = "example-ruby"

app "example-ruby" {
  labels = {
    "service" = "example-ruby",
    "env"     = "dev"
  }

  build {
    use "pack" {}
  }

  deploy {
    use "docker" {
      static_environment = {
        GEM_PATH = "/layers/heroku_ruby/gems/vendor/bundle/ruby/2.6.0"
        PATH     = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:bin:/layers/heroku_ruby/gems/vendor/bundle/ruby/2.6.0/bin"
      }
    }
  }
}
