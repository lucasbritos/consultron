/* CONFIG INCIAL */

\set envuser `echo "$POSTGRES_USER"`
\set envpass `echo "$POSTGRES_PASSWORD"`

create database application owner :envuser;
\connect application

CREATE SEQUENCE host_id_seq START 1;

CREATE TABLE project(
    project_id SERIAL PRIMARY KEY,
    project_name character varying(120) NOT NULL
);

CREATE TABLE template(
    template_id SERIAL PRIMARY KEY,
    template_name character varying(120) NOT NULL
);

CREATE TABLE oid(
    oid_id SERIAL PRIMARY KEY,
    oid_name character varying(120) NOT NULL,
    mib character varying(120),
    oid character varying(120) NOT NULL,
    type character varying(20) NOT NULL,	
    cols integer ARRAY,
    format jsonb
);

CREATE TABLE tables_schema(
    table_id SERIAL PRIMARY KEY,
    table_name character varying(120) NOT NULL
);

CREATE TABLE template_oid(
    table_id INTEGER REFERENCES tables_schema (table_id) ON DELETE CASCADE,
    oid_id INTEGER REFERENCES oid (oid_id) NOT NULL,
    template_id INTEGER REFERENCES template (template_id) ON DELETE CASCADE
    
);

CREATE TABLE host(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    community character varying(120) NOT NULL,
    ip_address character varying(120) NOT NULL,
    port integer NOT NULL,
    location character varying(120),
    template_id INTEGER REFERENCES template (template_id) NOT NULL,
    PRIMARY KEY (project_id, alias),
    FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE
);



CREATE TABLE apps(
    apps_id SERIAL NOT NULL,
    apps_name character varying NOT NULL,
    apps_query character varying NOT NULL,
    PRIMARY KEY (apps_id)
);


CREATE TABLE at_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    at_if_index integer,
    at_net_address character varying(120) COLLATE pg_catalog."default",
    at_phys_address character varying(120) COLLATE pg_catalog."default",
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE if_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index integer NOT NULL,
    if_index integer,
    if_descr character varying(120) COLLATE pg_catalog."default",
    if_mtu integer,
    if_speed bigint,
    if_admin integer,
    if_oper integer,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE if_x_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index integer NOT NULL,
    if_name character varying(160) COLLATE pg_catalog."default",
    if_alias character varying(160) COLLATE pg_catalog."default",
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE ip_addr_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index character varying(20) COLLATE pg_catalog."default" NOT NULL,
    ip_ad_ent_addr inet,
    ip_ad_ent_if_index integer,
    ip_ad_ent_net_mask inet,
    ip_ad_ent_bcast_addr integer,
    ip_ad_ent_reasm_max_size integer,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE ip_route_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    ip_route_dest inet,
    ip_route_if_index integer,
    ip_route_metric1 integer,
    ip_route_metric2 integer,
    ip_route_metric3 integer,
    ip_route_metric4 integer,
    ip_route_next_hop inet,
    ip_route_type integer,
    ip_route_proto integer,
    ip_route_age integer,
    ip_route_mask inet,
    ip_route_metric5 integer,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE ospf_if_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    ospf_if_ip_address inet,
    ospf_if_address_less_if integer,
    ospf_if_area_id inet,
    ospf_if_type integer,
    ospf_if_admin_stat integer,
    ospf_if_rtr_priority integer,
    ospf_if_transit_delay integer,
    ospf_if_retrans_interval integer,
    ospf_if_hello_interval integer,
    ospf_if_rtr_dead_interval integer,
    ospf_if_poll_interval integer,
    ospf_if_state integer,
    ospf_if_designated_router inet,
    ospf_if_backup_designated_router inet,
    ospf_if_events integer,
    ospf_if_auth_key character varying(40) COLLATE pg_catalog."default",
    ospf_if_status integer,
    ospf_if_multicast_forwarding integer,
    ospf_if_demand integer,
    ospf_if_auth_type integer,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE ospf_nbr_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    ospf_nbr_ip_address inet,
    ospf_nbr_address_less_index integer,
    ospf_nbr_rtr_id inet,
    ospf_nbr_options integer,
    ospf_nbr_priority integer,
    ospf_nbr_state integer,
    ospf_nbr_events integer,
    ospf_nbr_ls_retrans_q_len integer,
    ospf_nbma_nbr_status integer,
    ospf_nbma_nbr_performance integer,
    ospf_nbr_hello_suppressed integer,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE ospf_router_id
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    ospf_router_id inet,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE sys_descr
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    sys_descr character varying(2500) COLLATE pg_catalog."default",
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE sys_name
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    sys_name character varying(40) COLLATE pg_catalog."default",
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE cisco_cdp_cache_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    cdp_cache_if_index integer,
    cdp_cache_address_type integer,
    cdp_cache_address inet,
    cdp_cache_version character varying(2500),
    cdp_cache_device_id character varying(2500),
    cdp_cache_device_port character varying(160),
    cdp_cache_platform character varying(2500),
    cdp_cache_capabilities character varying(2500),
    cdp_cache_vtp_mgmt_domain character varying(2500),
    cdp_cache_native_vlan integer,
    cdp_cache_duplex integer,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

CREATE TABLE bgp_peer_table
(
    project_id INTEGER NOT NULL,
    alias character varying(120) NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    bgp_peer_identifier inet,
    bgp_peer_state integer,
    bgp_peer_admin_status integer,
    FOREIGN KEY (project_id,alias) REFERENCES host (project_id,alias) ON DELETE CASCADE
);

/* APPS */


INSERT INTO apps (apps_id,apps_name,apps_query) VALUES
(
1,
'cdpNeighbor',
'SELECT snt.sys_name as source, ccct.cdp_cache_device_id as target, host.location 
FROM cisco_cdp_cache_table ccct 
JOIN sys_name snt ON snt.alias = ccct.alias AND snt.project_id = ccct.project_id 
JOIN host ON host.alias = ccct.alias AND host.project_id = ccct.project_id'
);

INSERT INTO apps (apps_id,apps_name,apps_query) VALUES
(
2,
'sysDescrTable',
'SELECT snt.sys_name, sdt.sys_descr, host.location 
FROM public.sys_descr sdt 
JOIN public.sys_name snt ON snt.alias = sdt.alias AND snt.project_id = sdt.project_id 
JOIN host host ON snt.alias = host.alias AND snt.project_id = host.project_id'
);

INSERT INTO apps (apps_id,apps_name,apps_query) VALUES
(
3,
'interfaceTable',
'SELECT snt.sys_name, ift.if_descr, iat.ip_ad_ent_addr, iat.ip_ad_ent_net_mask, ift.if_oper, ift.if_admin, ixt.if_alias
FROM if_table ift
JOIN sys_name snt ON ift.alias = snt.alias AND ift.project_id = snt.project_id
LEFT JOIN ip_addr_table iat ON (ift.alias = iat.alias AND ift.project_id = iat.project_id AND iat.ip_ad_ent_if_index = ift.if_index) OR iat.ip_ad_ent_addr IS NULL
JOIN if_x_table ixt ON ixt.index = ift.if_index AND ixt.alias = ift.alias AND ixt.project_id = ift.project_id
JOIN host host ON snt.alias = host.alias AND snt.project_id = host.project_id
'
);

INSERT INTO apps (apps_id,apps_name,apps_query) VALUES
(
4,
'routeTable',
'SELECT snt.sys_name, rt.ip_route_dest, rt.ip_route_mask, rt.ip_route_next_hop, ift.if_descr, rt.ip_route_metric1, rt.ip_route_proto, rt.ip_route_type
FROM ip_route_table rt
JOIN sys_name snt ON snt.alias = rt.alias AND snt.project_id = rt.project_id
JOIN if_table ift ON ift.alias = rt.alias AND ift.project_id = rt.project_id AND ift.if_index = rt.ip_route_if_index
JOIN host host ON snt.alias = host.alias AND snt.project_id = host.project_id
'
);

INSERT INTO apps (apps_id,apps_name,apps_query) VALUES
(
5,
'ospfNeighbor',
'SELECT snt1.sys_name as source, snt2.sys_name as target, host.location as location
FROM ospf_nbr_table ont
JOIN sys_name snt1 ON snt1.alias = ont.alias AND snt1.project_id = ont.project_id
JOIN ospf_router_id ori ON ori.ospf_router_id = ont.ospf_nbr_rtr_id
JOIN sys_name snt2 ON snt2.alias = ori.alias AND snt2.project_id = ori.project_id
JOIN host host ON ori.alias = host.alias AND ori.project_id = host.project_id
'
);



/* TEMPLATES */



INSERT INTO template (template_id,template_name) VALUES (1,'CiscoNoRoute');
INSERT INTO template (template_id,template_name) VALUES (2,'CiscoRoute');
INSERT INTO template (template_id,template_name) VALUES (3,'CiscoNoRoute-Quilmes');

INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (1,'ifXTable','1.3.6.1.2.1.31.1.1','table','{1,18}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (2,'ifTable','1.3.6.1.2.1.2.2','table','{1,2,4,5,7,8}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (3,'ciscoCdpCacheTable','1.3.6.1.4.1.9.9.23.1.2.1','table','{1,3,4,5,6,7,8,9,10,11,12}','{"2":"formats.ipAddress"}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (4,'ospfNbrTable','1.3.6.1.2.1.14.10','table','{1,2,3,4,5,6,7,8,9,10,11}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,format) VALUES (5,'sysDesc','1.3.6.1.2.1.1.1.0','single','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,format) VALUES (6,'sysName','1.3.6.1.2.1.1.5.0','single','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (7,'bgpPeerTable','1.3.6.1.2.1.15.3','table','{1,2,3}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (8,'ipAddrTable','1.3.6.1.2.1.4.20','table','{1,2,3,4,5}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (9,'ipRouteTable','1.3.6.1.2.1.4.21','table','{1,2,3,4,5,6,7,8,9,10,11,12}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,format) VALUES (10,'ospfRouterId','1.3.6.1.2.1.14.1.1.0','single','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (11,'ciscoCdpCacheTable-Quilmes','1.3.6.1.4.1.9.9.23.1.2.1','table','{1,3,4,5,6,7,8,9,10,11,12}','{"2": "formats.ipAddress","0": "formats.defaultInt","8": "formats.defaultStr", "7": "formats.test"}';


INSERT INTO tables_schema (table_id,table_name) VALUES (1,'at_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (2,'if_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (3,'if_x_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (4,'ip_addr_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (5,'ip_route_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (6,'ospf_if_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (8,'ospf_nbr_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (9,'ospf_router_id');
INSERT INTO tables_schema (table_id,table_name) VALUES (10,'sys_descr');
INSERT INTO tables_schema (table_id,table_name) VALUES (11,'sys_name');
INSERT INTO tables_schema (table_id,table_name) VALUES (12,'cisco_cdp_cache_table');
INSERT INTO tables_schema (table_id,table_name) VALUES (13,'bgp_peer_table');

INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (3,1,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (2,2,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (12,3,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (8,4,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (10,5,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (11,6,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (13,7,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (4,8,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (9,10,1);

INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (3,1,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (2,2,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (12,3,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (8,4,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (10,5,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (11,6,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (13,7,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (4,8,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (9,10,2);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (5,9,2);

INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (3,1,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (2,2,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (12,11,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (8,4,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (10,5,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (11,6,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (13,7,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (4,8,3);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (9,10,3);


/* WORKBENCH */


INSERT INTO project (project_id,project_name) VALUES (1,'Testbench');

INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R1','R1','consultron_snmpsim_1',1024,'testbench', 2,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R2','R2','consultron_snmpsim_1',1024,'testbench', 2,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R3','R3','consultron_snmpsim_1',1024,'testbench', 2,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R4','R4','consultron_snmpsim_1',1024,'testbench', 2,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R5','R5','consultron_snmpsim_1',1024,'testbench', 2,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('tout','tout','consultron_snmpsim_1',1024,'testbench', 2,1);








