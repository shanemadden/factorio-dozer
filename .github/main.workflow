workflow "Publish" {
  on = "push"
  resolves = ["shanemadden/factorio-mod-portal-publish@1.0.0"]
}

action "shanemadden/factorio-mod-portal-publish@1.0.0" {
  uses = "shanemadden/factorio-mod-portal-publish@1.0.0"
}
