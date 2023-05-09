# This script requires the git CLI, sed, and rename in order to function

# Clones the templated repo to the provisioner execution environment via HTTPS
git clone https://oauth2:"$GITHUB_TOKEN"@github.com/"$OWNER"/"$WAYPOINT_PROJECT_NAME"

cd "$WAYPOINT_PROJECT_NAME"

# Finds all usages of %%wp_project%% in files and replaces with our project name
find . -type f -not -path '*/\.git/*' -exec sed -i.bak "s/%%[Ww]p_project%%/$WAYPOINT_PROJECT_NAME/" {} \;

# Finds all usages of %%gh_org%% in the files and replaces with our GitHub owner name
find . -type f -not -path '*/\.git/*' -exec sed -i.bak "s/%%gh_org%%/$OWNER/" {} \;

# Cleans up backup files from sed
find . -name "*.bak" -type f -delete

# Finds and renames directories with our project name where __wp_project__ is found
find . -depth -type d -execdir rename "s/__wp_project__/$WAYPOINT_PROJECT_NAME/" {} +

# Finds and renames files with our project name where __wp_project__ is found
find . -type f -exec rename "s/__wp_project__/$WAYPOINT_PROJECT_NAME/" {} +

# Enables push with HTTPS
git remote add origin https://"$GITHUB_TOKEN"/"$OWNER"/"$WAYPOINT_PROJECT_NAME".git/

# Add, commit, and push!
git add .
git commit -m "init: Render repo template with Waypoint project name."
git push origin
