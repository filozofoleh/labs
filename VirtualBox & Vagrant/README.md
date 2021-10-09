<h1>TASK 2.1</h1>



<h2>Part 1. Hypervisors</h2>  

 1. **What is the most popular hypervisors?**  
 
    *According to data for 2021, most popular Type 1 hypervisors is:*
    
   - VMware vSphere/EXSi
   - Hyper-V
   - Xen
   - RHEV

2. **Brief description of main differences between  popular hypervisors:**  

   *There are two main types of hypervisors: Type 1 & Type 2. The main differences between them can be seen in the table below.*  

| Criteria       | Type 1 Hypervisor                                     | Type 2 Hypervisor           |
|----------------|-------------------------------------------------------|-----------------------------|
| AKA            | Bare-metal or Native                                  | Hosted                      |
| Definition     |  Runs directly on the system with VMs running on them | Runs on the conventional OS |
| Virtualization | Hardware virtualization                               | OS virtualization           |
| Scalability    | Better scalability                                    | No so much                  |
| Speed          | Faster                                                | Slower                      |
| Performance    | Higher-performance                                    | Lower-performance           |
| Security       | More secure                                           | Less secure                 |


   *Also hypervisors are divided into*
- Type 3(Monolithic) 
 *Includes hardware device drivers*
- Type 4(Microkernel)
   *Drivers located inside Host OS*


<h2>Part 2. Work with VirtualBox </h2>  

 1. **First run** 
   
 - Download and install latest version of VirtualBox  
 
 ![packages for Linux](images/1.png)  
 
 - Download Ubuntu 21.04_amd64  
 
  ![Ubuntu official ISO](images/2.png)
  
  - Create VM1 and install Ubuntu   
  
  ![Successful installation](images/3a.png)

 - Configuration of VM1  

![Settings](images/3.png)

    
   2. **Clone VM1 , create VM2.**   
   
   ![Clone](images/4.png)    
   ![Clone](images/5.png)    

  3. **Create group "Test"**
  
  ![Create Group ](images/6.png)    

 4. **Take a snapshots, create a tree of snapshots**  

 ![Tree of snapshots](images/7.png)   

5. **Export & Import VM**

![Export VM'](images/8.png)  
![Import VM'](images/9.png)   

6. **Configuration of VMs**

![Configuration options](images/10.png) 

-  USB connection 

   download  and install Extension Package for VB   
    
    ![Install extension](images/11.png) 

    add USB device
 
    ![add usb storage](images/12.png) 

  - Configure a shared folder  
  ![Install guest additions](images/13.png)     
  ![Shared folder was configured](images/14.png)   

- Check network connection   

|                  | VM to HOST  | HOST to VM  | VM1 to VM2  | Internet    |
|------------------|-------------|-------------|-------------|-------------|
| Bridged Adapter  | +           | +           | +           | +           |
| NAT              | +           | Unreachable | Unreachable | +           |
| Internal Network | Unreachable | Unreachable | +           | Unreachable |
|                  |             |             |             |             |

![vm to host ping](images/15.png) 

7. **Work with CLI through VBoxManage**  

- Check the man page VBoxManage  
  
  ![vboxmanage man](images/16.png) 

- Execute basic commands  

![run commands](images/17.png)   
![modify ](images/18.png)   
![restart](images/19.png)   

<h2>Part 3. Work with Vagrant</h2>

1. **Download Vagrant**    

![download](images/20.png)   

2. **Initialize the environment and SSH connection**   

![init xenial](images/21.png)    
![guest additions](images/22.png)  

3. **Record the date**  

![date](images/23.png)  

4. **Stop & Delete VM**  

![halt_destroy](images/24.png)

5. **Create a Vagrant Box**  
![halt_destroy](images/24.png)

![create](images/25.png)  
![succss](images/26.png)  

6. **Create a LAMP test environment**  

![createlamp](images/27.png)  
![LAMP](images/28.png)  



