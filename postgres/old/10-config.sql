\set envuser `echo "$POSTGRES_USER"`

create database configuration owner :envuser;
\connect configuration

CREATE TABLE schematic(
    schematic_id SERIAL PRIMARY KEY,
    schematic_name character varying(120) NOT NULL,
    db_original character varying(120) NOT NULL
);

CREATE TABLE project(
    project_id SERIAL PRIMARY KEY,
    project_name character varying(120) NOT NULL,
    db_name character varying(120) NOT NULL,
    schematic_id INTEGER REFERENCES schematic (schematic_id) NOT NULL
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

CREATE TABLE host(
    host_id SERIAL PRIMARY KEY,
    alias character varying(120),
    community character varying(120) NOT NULL,
    ip_address inet NOT NULL,
    port integer NOT NULL,
    location character varying(120),
    template_id INTEGER REFERENCES template (template_id) NOT NULL,
    project_id INTEGER REFERENCES project (project_id) NOT NULL
);

CREATE TABLE template_table_oid(
    schematic_id INTEGER REFERENCES schematic (schematic_id) NOT NULL,
    table_name character varying(120) NOT NULL,
    oid_id INTEGER REFERENCES oid (oid_id) NOT NULL,
    template_id INTEGER REFERENCES template (template_id) NOT NULL
);

/* CONFIG INCIAL TESTING */


INSERT INTO schematic (schematic_name,db_original) VALUES ('network1', 'network1_template');
INSERT INTO project (project_name,schematic_id,db_name) VALUES ('Project1', 1,'Project1_network1');

INSERT INTO template (template_name) VALUES ('CiscoNoRoute');

INSERT INTO oid (oid_name,oid,type,cols) VALUES ('ifXTable','1.3.6.1.2.1.31.1.1','table','{1,18}');
INSERT INTO oid (oid_name,oid,type,cols) VALUES ('ifTable','1.3.6.1.2.1.2.2','table','{1,2,5,7,8}');
INSERT INTO oid (oid_name,oid,type,cols,format) VALUES ('ciscoCdpCacheTable','1.3.6.1.4.1.9.9.23.1.2.1','table','{1,3,4,5,6,7,8,10,12}','{"2":"ipAddress"}');
INSERT INTO oid (oid_name,oid,type,cols) VALUES ('ospfNbrTable','1.3.6.1.2.1.14.1.1.0','table','{1,2,3,4,5,6,7,8,9,10,11}');
INSERT INTO oid (oid_name,oid,type) VALUES ('sysDesc','1.3.6.1.2.1.1.1.0','single');
INSERT INTO oid (oid_name,oid,type) VALUES ('sysName','1.3.6.1.2.1.1.5.0','single');

INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R1','R1','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R2','R2','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R3','R3','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R4','R4','127.0.0.1',161,'testbench', 1,1);
INSERT INTO host (alias,community,ip_address,port,location,template_id,project_id) VALUES ('R5','R5','127.0.0.1',161,'testbench', 1,1);



INSERT INTO template_table_oid (schematic_id,table_name,oid_id,template_id) VALUES (1,'if_x_table',1,1);
INSERT INTO template_table_oid (schematic_id,table_name,oid_id,template_id) VALUES (1,'if_table',2,1);
/*INSERT INTO template_table_oid (schematic_id,table_name,oid_id,template_id) VALUES (1,'',3,1)*/
INSERT INTO template_table_oid (schematic_id,table_name,oid_id,template_id) VALUES (1,'ospf_nbr_table',4,1);
INSERT INTO template_table_oid (schematic_id,table_name,oid_id,template_id) VALUES (1,'sys_descr',5,1);
INSERT INTO template_table_oid (schematic_id,table_name,oid_id,template_id) VALUES (1,'sys_name',6,1);

CREATE DATABASE Project1_network1 WITH TEMPLATE network1_template OWNER :envuser;



