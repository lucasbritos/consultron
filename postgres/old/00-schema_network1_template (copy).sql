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
    alias character varying(120),
    community character varying(120) NOT NULL,
    ip_address inet NOT NULL,
    port integer NOT NULL,
    location character varying(120),
    template_id INTEGER REFERENCES template (template_id) NOT NULL,
    PRIMARY KEY (project_id, alias),
    CONSTRAINT host_project_id_fkey FOREIGN KEY (project_id)
        REFERENCES public.project (project_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE at_table
(
    host_id bigint NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    at_if_index integer,
    at_net_address character varying(120) COLLATE pg_catalog."default",
    at_phys_address character varying(120) COLLATE pg_catalog."default",
    CONSTRAINT at_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE if_table
(
    host_id bigint NOT NULL,
    index integer NOT NULL,
    if_descr character varying(120) COLLATE pg_catalog."default",
    if_speed bigint,
    if_oper integer,
    if_admin integer,
    if_index integer,
    CONSTRAINT interfaces_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE if_x_table
(
    host_id bigint NOT NULL,
    index integer NOT NULL,
    if_name character varying(160) COLLATE pg_catalog."default",
    if_alias character varying(160) COLLATE pg_catalog."default",
    CONSTRAINT if_x_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE ip_addr_table
(
    host_id bigint NOT NULL,
    ip_ad_ent_addr inet,
    ip_ad_ent_if_index integer,
    ip_ad_ent_net_mask inet,
    ip_ad_ent_reasm_max_size integer,
    index character varying(20) COLLATE pg_catalog."default" NOT NULL,
    ip_ad_ent_bcast_addr integer,
    CONSTRAINT ip_addr_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE ip_route_table
(
    host_id bigint NOT NULL,
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
    CONSTRAINT ip_route_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE ospf_if_table
(
    host_id bigint NOT NULL,
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
    CONSTRAINT ospf_if_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE ospf_nbr_table
(
    host_id bigint NOT NULL,
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
    CONSTRAINT ospf_nbr_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE ospf_router_id
(
    host_id bigint NOT NULL,
    ospf_router_id inet,
    CONSTRAINT ospf_router_id_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE sys_descr
(
    host_id bigint NOT NULL,
    sys_descr character varying(2500) COLLATE pg_catalog."default",
    CONSTRAINT sys_descr_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE sys_name
(
    host_id bigint NOT NULL,
    sys_name character varying(40) COLLATE pg_catalog."default",
    CONSTRAINT sys_name_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE cdp_cache_table
(
    host_id bigint NOT NULL,
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
    CONSTRAINT cdp_cache_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (host_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);





/* CONFIG INCIAL TESTING */


INSERT INTO project (project_id,project_name) VALUES (1,'Project1');

INSERT INTO template (template_id,template_name) VALUES (1,'CiscoNoRoute');

INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (1,'ifXTable','1.3.6.1.2.1.31.1.1','table','{1,18}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (2,'ifTable','1.3.6.1.2.1.2.2','table','{1,2,5,7,8}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (3,'ciscoCdpCacheTable','1.3.6.1.4.1.9.9.23.1.2.1','table','{1,3,4,5,6,7,8,9,10,11,12}','{"2":"formats.ipAddress"}');
INSERT INTO oid (oid_id,oid_name,oid,type,cols,format) VALUES (4,'ospfNbrTable','1.3.6.1.2.1.14.10','table','{1,2,3,4,5,6,7,8,9,10,11}','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,format) VALUES (5,'sysDesc','1.3.6.1.2.1.1.1.0','single','{}');
INSERT INTO oid (oid_id,oid_name,oid,type,format) VALUES (6,'sysName','1.3.6.1.2.1.1.5.0','single','{}');

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
INSERT INTO tables_schema (table_id,table_name) VALUES (12,'cdp_cache_table');



INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R1','R1','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R2','R2','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R3','R3','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R4','R4','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R5','R5','127.0.0.1',161,'testbench', 1,1);



INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (3,1,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (2,2,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (12,3,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (8,4,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (10,5,1);
INSERT INTO template_oid (table_id,oid_id,template_id) VALUES (11,6,1);








