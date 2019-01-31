\set envuser `echo "$POSTGRES_USER"`
\set envpass `echo "$POSTGRES_PASSWORD"`

create database network1_template owner :envuser;
\connect network1_template

CREATE SEQUENCE host_id_seq START 1;

CREATE TABLE host
(
    id bigint NOT NULL DEFAULT nextval('host_id_seq'::regclass),
    alias character varying(120) COLLATE pg_catalog."default" NOT NULL,
    ip_address inet NOT NULL,
    snmp_comm character varying(20) COLLATE pg_catalog."default" NOT NULL,
    location character varying(40) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT host_pkey PRIMARY KEY (id)
);

CREATE TABLE at_table
(
    host_id bigint NOT NULL,
    index character varying(40) COLLATE pg_catalog."default" NOT NULL,
    at_if_index integer,
    at_net_address character varying(120) COLLATE pg_catalog."default",
    at_phys_address character varying(120) COLLATE pg_catalog."default",
    CONSTRAINT at_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
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
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE if_x_table
(
    host_id bigint NOT NULL,
    index integer NOT NULL,
    if_name character varying(160) COLLATE pg_catalog."default",
    if_alias character varying(160) COLLATE pg_catalog."default",
    CONSTRAINT if_x_table_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
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
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
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
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
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
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
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
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE ospf_router_id
(
    host_id bigint NOT NULL,
    ospf_router_id inet,
    CONSTRAINT ospf_router_id_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE sys_descr
(
    host_id bigint NOT NULL,
    sys_descr character varying(2500) COLLATE pg_catalog."default",
    CONSTRAINT sys_descr_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE sys_name
(
    host_id bigint NOT NULL,
    sys_name character varying(40) COLLATE pg_catalog."default",
    CONSTRAINT sys_name_host_id_fkey FOREIGN KEY (host_id)
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
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
        REFERENCES public.host (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);


