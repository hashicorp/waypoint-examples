# node-js-getting-started

A barebones Node.js app using [Express 4](http://expressjs.com/).

# Waypoint setup

In addition to setting up Waypoint, you may need to:

Enable Google Cloud Run

```
https://console.developers.google.com/apis/library/run.googleapis.com?project=<my-project-name>
```

Add "Cloud Run Admin" to your service account permissions at GCP.

Install the Waypoint server to a local Docker instance.

```
waypoint install --platform=docker -accept-tos
```

Authenticate to Google Cloud (or
 `export GOOGLE_APPLICATION_CREDENTIALS="~/google-credentials.json"`)

```
gcloud auth login
```

Configure Docker for Google Cloud

```
gcloud auth configure-docker
```

Set your project id.

```
gcloud config set project PROJECT_ID
```

See also `waypoint.hcl` where you must edit a few instances of `my-project-id` 
to match your Google Cloud Project ID.