<h1>Task 6.2</h1>



<h2>VM1 - NAT and internal, VM2, VM3 – internal interfaces </h2>


<h3>Install and configure DHCP server on VM1</h3>

 *Install and configure **SC-DHSPSERVER***    
 
 ![img](images/1.png)  

***/etc/dhcp/dhcpd.conf***  

![img](images/2.png)  


  ***/etc/default/isc-dhcp-server***  

![img](images/3.png)  

***restart***

![img](images/4.png)  

  ***Check config***

![img](images/5.png)  

***Enable forwarding /etc/sysctl.conf***

![img](images/6.png)  

  ***Add rules in Iptables***

![img](images/7.png)  

***Chech the result***
  
![img](images/8.png)  
  


<h3>Install and configure DHCP & DNS server using dnsmasq</h3>

***Install and enable dnsmasq***

![img](images/9.png)   


***/etc/dnsmasq.conf***

![img](images/10.png)  

***Check syntax***

![img](images/11.png)  

***Check the configuration of VMs***

![img](images/12.png)  

***Test the connection***

![img](images/13.png)  



<h3>Configure dynamic routing using OSPF protocol</h3>
