# Terraform AWS Module - PAN Bootstrap in AWS for Aviatrix

Terraform Module to Bootstrap Palo Alto Networks VM-Series Firewall on AWS for Aviatrix Firenet.
Reference: https://docs.aviatrix.com/HowTos/bootstrap_example.html#

## Usage with minimal customisation
Default admin credential: admin/Aviatrix123#
Default api user credential: api-user/Aviatrix123#

```hcl
module "pan-bootstrap-aviatrix" {
  source  = "bayupw/pan-bootstrap-aviatrix/aws"
  version = "1.0.1"
}
```

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/bayupw/terraform-aws-pan-bootstrap-aviatrix/issues/new) section.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/bayupw/terraform-aws-pan-bootstrap-aviatrix/tree/master/LICENSE) for full details.
