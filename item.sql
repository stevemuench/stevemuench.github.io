create table item 
(
    id number, 
	type varchar2(20), 
	name varchar2(80), 
	description varchar2(255), 
	price number, 
	width_cm number, 
	height_cm number, 
	artist varchar2(80), 
	medium varchar2(80), 
	ram_gb number, 
	disk_gb number, 
	num_esims number, 
	num_sims number, 
	cellular_radio varchar2(20)
)
/
insert into item (id,type,name,description,price,width_cm,height_cm,artist,medium,ram_gb,disk_gb,num_esims,num_sims,cellular_radio) 
values (1,'ARTWORK','Just a Pinch','Chalk drawing',995,40,60,'Peter de Seve','Pencil on Paper',null,null,null,null,null);
insert into item (id,type,name,description,price,width_cm,height_cm,artist,medium,ram_gb,disk_gb,num_esims,num_sims,cellular_radio) 
values (2,'COMPUTER','Mac Mini','Mac Mini (Project RED)',1599,null,null,null,null,96,2000,null,null,null);
insert into item (id,type,name,description,price,width_cm,height_cm,artist,medium,ram_gb,disk_gb,num_esims,num_sims,cellular_radio) 
values (3,'ARTWORK','Lincoln Center','4th New York Film Festival',null,60,80,'Roy Lichtenstein','Vintage Poster',null,null,null,null,null);
insert into item (id,type,name,description,price,width_cm,height_cm,artist,medium,ram_gb,disk_gb,num_esims,num_sims,cellular_radio) 
values (4,'COMPUTER','Mac Pro','Mac Pro',18595,null,null,null,null,128,8000,null,null,null);
insert into item (id,type,name,description,price,width_cm,height_cm,artist,medium,ram_gb,disk_gb,num_esims,num_sims,cellular_radio) 
values (5,'ARTWORK','La Guyabera Cubana','Painted Cuban guyabera shirt with Cuban flag pockets',250,65,90,'Mora','Acrylic on Panel',null,null,null,null,null);
insert into item (id,type,name,description,price,width_cm,height_cm,artist,medium,ram_gb,disk_gb,num_esims,num_sims,cellular_radio) 
values (6,'SMARTPHONE','iPhone 15 Pro','The iPhone 15 Pro (Project RED) features a sleek titanium design with an A17 chip for peak performance, and a next-gen camera for unparalleled photo quality. ',999,null,null,null,null,512,2000,2,2,'5G');
insert into item (id,type,name,description,price,width_cm,height_cm,artist,medium,ram_gb,disk_gb,num_esims,num_sims,cellular_radio) 
values (7,'SMARTPHONE','Samsung M32','The Samsung Galaxy M32 boasts a 6.4-inch Super AMOLED 90Hz display, MediaTek Helio G80, a 6000mAh battery, and a quad-camera setup, offering vibrant visuals and lasting performance.',345,null,null,null,null,128,512,0,1,'4G');
commit
/