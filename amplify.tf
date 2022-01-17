resource "aws_amplify_app" "Wildrydes" {
  name       = "Wildrydes"
  repository = "https://github.com/selenerescio/amplify.git"
# GitHub personal access token
  access_token = "" #wait for Pascal
# The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  #Auto Branch Creation
  enable_auto_branch_creation = true
  
  build_spec = <<-EOT
  version: 1
  frontend:
    phases:
      preBuild:
        commands:
          - npm ci
      # IMPORTANT - Please verify your build commands
      build:
        commands: []
    artifacts:
      # IMPORTANT - Please verify your build output directory
      baseDirectory: /
      files:
        - '**/*'
    cache:
      paths:
        - node_modules/**/*
  EOT


  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build = true
}

}
resource "aws_amplify_branch" "AmplifyFeature" {
  app_id      = aws_amplify_app.Wildrydes.id
  branch_name = "main" # must match the branch name in github where all the files are
  stage     = "PRODUCTION"
}