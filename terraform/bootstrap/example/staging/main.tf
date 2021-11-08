module "web_server_env_1" {
    path          = ".modules"
    instance_type = "t3.micro"
    cidr_block    = "10.0.1.0/24"
    instance_count = 1
    tags          = merge(var.default_tags,{ Env = "staging" })
}
