create table tb_language
(
    language_uuid varchar(36) not null
        constraint tb_language_pk
            primary key,
    kor           text,
    en            text,
    cn            text,
    jp            text
);

alter table tb_language
    owner to root;

create table tb_map
(
    map_uuid varchar(36) not null
        constraint tb_map_pk
            primary key,
    map_name varchar(36) not null
        constraint tb_map_tb_language_language_id_fk
            references tb_language
);

alter table tb_map
    owner to root;

create table tb_user
(
    user_uuid     varchar(36)             not null
        constraint tb_user_pk
            primary key,
    user_nickname varchar(36)             not null,
    user_id       varchar(36)             not null,
    user_password text                    not null,
    user_salt     varchar(128)            not null,
    created_at    timestamp default now() not null,
    updated_at    timestamp,
    deleted_at    timestamp,
    x             integer,
    y             integer,
    gender        smallint,
    map_uuid      varchar(36)
        constraint tb_user_tb_map_map_uuid_fk
            references tb_map,
    direction     smallint
);

alter table tb_user
    owner to root;

create table tb_pokemon
(
    pokemon_uuid          varchar(36)      not null
        constraint tb_pokemon_pk
            primary key,
    pokemon_name          varchar(36)      not null
        constraint tb_pokemon_tb_language_language_id_fk
            references tb_language,
    pokemon_type_relation varchar(36)      not null,
    size                  double precision not null,
    weight                double precision not null
);

alter table tb_pokemon
    owner to root;

create table tb_pokemon_type
(
    pokemon_type_uuid varchar(36) not null
        constraint tb_pokemon_type_pk
            primary key,
    pokemon_type_name varchar(36) not null
        constraint tb_pokemon_type_tb_language_language_id_fk
            references tb_language
);

alter table tb_pokemon_type
    owner to root;

create table tb_pokemon_type_relation
(
    pokemon_type_relation_uuid varchar(36) not null
        constraint tb_pokemon_type_relation_pk
            primary key,
    pokemon_uuid               varchar(36) not null
        constraint tb_pokemon_type_relation_tb_pokemon_pokemon_uuid_fk
            references tb_pokemon,
    pokemon_type_uuid          varchar(36) not null
        constraint tb_pokemon_type_relation_tb_pokemon_type_pokemon_type_id_fk
            references tb_pokemon_type
);

alter table tb_pokemon_type_relation
    owner to root;

alter table tb_pokemon
    add constraint tb_pokemon_tb_pokemon_type_relation_pokemon_type_relation_id_fk
        foreign key (pokemon_type_relation) references tb_pokemon_type_relation;

create table tb_skill_type
(
    skill_type_uuid varchar(36) not null
        constraint tb_skill_type_pk
            primary key,
    skill_name      varchar(36) not null
        constraint tb_skill_type_tb_language_language_id_fk
            references tb_language
);

alter table tb_skill_type
    owner to root;

create table tb_skill_division
(
    skill_division_uuid varchar(36) not null
        constraint tb_skill_division_pk
            primary key,
    skill_division_name varchar(36) not null
        constraint tb_skill_division_tb_language_language_id_fk
            references tb_language
);

alter table tb_skill_division
    owner to root;

create table tb_skill
(
    skill_uuid varchar(36)      not null
        constraint tb_skill_pk
            primary key,
    skill_name varchar(36)      not null
        constraint tb_skill_tb_language_language_id_fk
            references tb_language,
    damage     double precision not null,
    accuracy   double precision not null,
    type       varchar(36)      not null
        constraint tb_skill_tb_skill_type_skill_type_id_fk
            references tb_skill_type,
    division   varchar(36)      not null
        constraint tb_skill_tb_skill_division_skill_division_id_fk
            references tb_skill_division,
    priority   integer          not null
);

comment on column tb_skill.damage is '데미지';

comment on column tb_skill.accuracy is '명중률';

alter table tb_skill
    owner to root;

create table tb_item_category
(
    item_category_uuid varchar(36) not null
        constraint tb_item_category_pk
            primary key,
    item_category_name varchar(36) not null
        constraint tb_item_category_tb_language_language_id_fk
            references tb_language
);

alter table tb_item_category
    owner to root;

create table tb_item
(
    item_uuid        varchar(36) not null
        constraint tb_item_pk
            primary key,
    item_name        varchar(36) not null
        constraint tb_item_tb_language_language_id_fk
            references tb_language,
    item_category    varchar(36) not null
        constraint tb_item_tb_item_category_item_category_id_fk
            references tb_item_category,
    item_description varchar(36) not null
        constraint tb_item_tb_language_language_id_fk_2
            references tb_language,
    max              integer     not null
);

alter table tb_item
    owner to root;

create table tb_item_inventory
(
    item_inventory_uuid varchar(36) not null
        constraint tb_item_inventory_pk
            primary key,
    user_uuid           varchar(36) not null
        constraint tb_item_inventory_tb_user_user_uuid_fk
            references tb_user,
    item_uuid           varchar(36) not null
        constraint tb_item_inventory_tb_item_item_uuid_fk
            references tb_item
);

alter table tb_item_inventory
    owner to root;

create table tb_pokemon_inventory
(
    pokemon_inventory_uuid varchar(36) not null
        constraint tb_pokemon_inventory_pk
            primary key,
    user_uuid              varchar(36) not null
        constraint tb_pokemon_inventory_tb_user_user_uuid_fk
            references tb_user,
    pokemon_uuid           varchar(36) not null
        constraint tb_pokemon_inventory_tb_pokemon_pokemon_uuid_fk
            references tb_pokemon,
    item_uuid              varchar(36) not null
        constraint tb_pokemon_inventory_tb_item_item_uuid_fk
            references tb_item,
    type                   smallint    not null,
    intimacy               integer     not null,
    level                  integer     not null,
    exp                    integer     not null,
    hp                     integer
);

comment on table tb_pokemon_inventory is 'pc';

comment on column tb_pokemon_inventory.intimacy is '친밀도';

alter table tb_pokemon_inventory
    owner to root;

create table tb_pokemon_inventory_skill_relation
(
    pokemon_inventory_skill_uuid varchar(36) not null
        constraint tb_pokemon_inventory_skill_relation_pk
            primary key,
    pokemon_inventory_uuid       varchar(36) not null
        constraint tb_pokemon_inventory_skill_relation_tb_pokemon_inventory_pokemo
            references tb_pokemon_inventory,
    skill_uuid                   varchar(36) not null
        constraint tb_pokemon_inventory_skill_relation_tb_skill_skill_uuid_fk
            references tb_skill,
    power_point                  integer     not null,
    use                          smallint    not null
);

alter table tb_pokemon_inventory_skill_relation
    owner to root;

create table tb_pokemon_spawn
(
    pokemon_spawn_uuid varchar(36)      not null
        constraint tb_pokemon_spawn_pk
            primary key,
    pokemon_uuid       varchar(36)      not null
        constraint tb_pokemon_spawn_tb_pokemon_pokemon_uuid_fk
            references tb_pokemon,
    map_uuid           varchar(36)      not null
        constraint tb_pokemon_spawn_tb_map_map_uuid_fk
            references tb_map,
    probability        double precision not null
);

alter table tb_pokemon_spawn
    owner to root;

create table tb_npc
(
    npc_uuid varchar(36) not null
        constraint tb_npc_pk
            primary key,
    npc_name varchar(36) not null
        constraint tb_npc_tb_language_language_id_fk
            references tb_language
);

alter table tb_npc
    owner to root;

create table tb_story_flag
(
    flag_uuid varchar(36) not null
        constraint tb_story_flag_pk
            primary key
);

alter table tb_story_flag
    owner to root;

create table tb_client
(
    client_uuid    varchar(36)                                    not null
        constraint tb_client_pk
            primary key,
    client_status  integer     default 0                          not null,
    client_version varchar(25) default '1.0.0'::character varying not null,
    created_at     timestamp   default now()                      not null,
    updated_at     timestamp,
    server_cdn     text                                           not null,
    server_version varchar(25) default '1.0.0'::character varying not null,
    server_status  integer     default 0                          not null
);

comment on column tb_client.server_cdn is 'http/https';

alter table tb_client
    owner to root;

create table tb_admin
(
    admin_uuid     varchar(36) not null
        constraint tb_admin_pk
            primary key,
    admin_id       varchar(36) not null,
    admin_password text        not null,
    admin_salt     integer
);

alter table tb_admin
    owner to root;

create table tb_story_flag_user_relation
(
    story_flag_relation_uuid varchar(36)             not null
        constraint tb_story_flag_user_relation_pk
            primary key,
    user_uuid                varchar(36)             not null
        constraint tb_story_flag_user_relation_tb_user_user_uuid_fk
            references tb_user,
    flag_uuid                varchar(36)             not null
        constraint tb_story_flag_user_relation_tb_story_flag_flag_uuid_fk
            references tb_story_flag,
    created_at               timestamp default now() not null
);

alter table tb_story_flag_user_relation
    owner to root;

create table tb_blacklist
(
    blacklist_uuid varchar(36)             not null
        constraint tb_blacklist_pk
            primary key,
    user_uuid      varchar(36)             not null
        constraint tb_blacklist_tb_user_user_uuid_fk
            references tb_user,
    description    text                    not null,
    created_at     timestamp default now() not null,
    started_at     timestamp               not null,
    ended_at       timestamp               not null
);

alter table tb_blacklist
    owner to root;

