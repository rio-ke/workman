# Creating AWS ebs disk

`Note`

- For all instances default volume will create automatically.

**create ebs disk**

![Image](https://github.com/januo-org/proof-of-concepts/assets/88568938/532369fd-1f01-4af3-8c18-c3c53808d49c)

* In the navigation pane, choose Volumes
* Choose Create volume
* Choose Suitable General Purpose volume typs
* Choose size(8GiB) and Availability Zone
* And give tag name as extra-volume
* save the volume setting.

![Image](https://github.com/januo-org/proof-of-concepts/assets/88568938/8ccb4fc0-1f8a-41d9-8ad9-1d9cad709d47)

**Attach volume to EC2**

- Once volume created wait for volume state to be Available condition
- Select Extra-volume
- Go click `Action` and attach volume
- In basic details choose EC2 instance
- Give Device name as /dev/xvdk
- Save and Attach volume.

![Image](https://github.com/januo-org/proof-of-concepts/assets/88568938/9ed3b68e-1fe6-44ae-81f6-1cb58108e809)




