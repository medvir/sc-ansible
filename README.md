## sc-ansible

Ansible playbook to configure a _pet_ instance on Science Cloud.


### Instructions

So far this only configures `timavo`, a 16.04 LTS Ubuntu, with specific
configuration/software.

`ansible` must available on your local machine (you might also need `aptitude`
on the remote machine), simply check out and run `./ansible`.


### One important note on security groups

In order to allow samba access to instances on Science Cloud, a special
security group must be created in Open Stack and added to an instance.

In the Open Stack dashboard go to COMPUTE -> Access & Security, click
'Create Security Group' and choose a relevant name (like 'samba'). From the
dropdown menu of 'samba', click on 'Manage Rules' and then click 'Add Rule'.
You will need to add four rules for samba to work:

- Rule: Custom TCP rule, Direction: Ingress, Open Port: Port Range, from-to: 137-139
- Rule: Custom TCP rule, Direction: Ingress, Open Port: Port, Port: 445
- Rule: Custom UDP rule, Direction: Ingress, Open Port: Port Range, from-to: 137-139
- Rule: Custom UDP rule, Direction: Ingress, Open Port: Port, Port: 445

In all cases, leave CIDR.

Finally, you need to add the security group 'samba' to the instance you want to
connect to with samba. Go to 'COMPUTE' -> 'Instances' and, from the relevant
instance, select 'Edit Security Groups' from the dropdown menu, add 'samba'.
