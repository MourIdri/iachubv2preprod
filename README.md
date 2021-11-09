Quick demo for a HUB on Azure using terraform files

*************
IaaS as code using terraform envirronement. The Terraform files are intented to be used along with Azure DevOps pipelines to be deployed. You can fork this Github Repo and use it to enjoy Azure DevOps. Folder is : terraform-iac

Post configuration initialy done (Domain join, routing etc... ) . Folder is : ansible-postconf

Notes : v1 does not include PaaS services for security firewalling and routing but rely on Linux tooling for Router ( Iptable and route table )  and WAF ( Nginx ) . For Site to Site conection, native azure VPN is used. 

*************

![Alt text](/hub_v1.jpg?raw=true "hub topology demo")


