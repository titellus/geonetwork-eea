REM ======================================================================
REM ===   Sql Script for Database : Geonet
REM ===
REM === Build : 153
REM ======================================================================

CREATE TABLE Relations
  (
    id         int,
    relatedId  int,
    primary key(id,relatedId)
  );

REM ======================================================================

CREATE TABLE Categories
  (
    id    int,
    name  varchar2(255)   not null,
    primary key(id),
    unique(name)
  );

REM ======================================================================

CREATE TABLE CustomElementSet
  (
    xpath  varchar2(1000) not null
  );

REM ======================================================================

CREATE TABLE Settings
  (
    id        int,
    parentId  int,
    name      varchar2(64)    not null,
    value     clob,
    primary key(id)
  );

REM ======================================================================

CREATE TABLE Languages
  (
    id    varchar2(5),
    name  varchar2(32)   not null,
    isInspire char(1)     default 'n',
    isDefault char(1)     default 'n',
    primary key(id)
  );

REM ======================================================================

CREATE TABLE Sources
  (
    uuid     varchar2(250),
    name     varchar2(250),
    isLocal  char(1)        default 'y',
    primary key(uuid)
  );

REM ======================================================================

CREATE TABLE IsoLanguages
  (
    id    int,
    code  varchar2(3)   not null,
    shortcode varchar2(2),
    primary key(id),
    unique(code)
  );

REM ======================================================================

CREATE TABLE IsoLanguagesDes
  (
    idDes   int,
    langId  varchar2(5),
    label   varchar2(96)   not null,
    primary key(idDes,langId)
  );

REM ======================================================================

CREATE TABLE Regions
  (
    id     int,
    north  float   not null,
    south  float   not null,
    west   float   not null,
    east   float   not null,
    primary key(id)
  );

REM ======================================================================

CREATE TABLE RegionsDes
  (
    idDes   int,
    langId  varchar2(5),
    label   varchar2(96)   not null,
    primary key(idDes,langId)
  );

REM ======================================================================

CREATE TABLE Users
  (
    id            int,
    username      varchar2(256)    not null,
    password      varchar2(40)    not null,
    surname       varchar2(32),
    name          varchar2(32),
    profile       varchar2(32)    not null,
    address       varchar2(128),
    city          varchar2(128),
    state         varchar2(32),
    zip           varchar2(16),
    country       varchar2(128),
    email         varchar2(128),
    organisation  varchar2(128),
    kind          varchar2(16),
    primary key(id),
    unique(username)
  );

REM ======================================================================

CREATE TABLE Operations
  (
    id        int,
    name      varchar2(32)   not null,
    reserved  char(1)       default 'n' not null,
    primary key(id)
  );

REM ======================================================================

CREATE TABLE OperationsDes
  (
    idDes   int,
    langId  varchar2(5),
    label   varchar2(96)   not null,
    primary key(idDes,langId)
  );

REM ======================================================================

CREATE TABLE Requests
  (
    id             int,
    requestDate    varchar2(30),
    ip             varchar2(128),
    query          varchar2(4000),
    hits           int,
    lang           varchar2(16),
    sortBy         varchar2(128),
    spatialFilter  varchar2(4000),
    type           varchar2(4000),
    simple         int             default 1,
    autogenerated  int             default 0,
    service        varchar2(128),
    primary key(id)
  );

CREATE INDEX RequestsNDX1 ON Requests(requestDate);
CREATE INDEX RequestsNDX2 ON Requests(ip);
CREATE INDEX RequestsNDX3 ON Requests(hits);
CREATE INDEX RequestsNDX4 ON Requests(lang);

REM ======================================================================

CREATE TABLE Params
  (
    id          int,
    requestId   int,
    queryType   varchar2(128),
    termField   varchar2(128),
    termText    varchar2(128),
    similarity  float,
    lowerText   varchar2(128),
    upperText   varchar2(128),
    inclusive   char(1),
    primary key(id),
    foreign key(requestId) references Requests(id)
  );

CREATE INDEX ParamsNDX1 ON Params(requestId);
CREATE INDEX ParamsNDX2 ON Params(queryType);
CREATE INDEX ParamsNDX3 ON Params(termField);
CREATE INDEX ParamsNDX4 ON Params(termText);

REM ======================================================================

CREATE TABLE HarvestHistory
  (
    id             int not null,
    harvestDate    varchar2(30),
    harvesterUuid  varchar2(250),
    harvesterName  varchar2(128),
    harvesterType  varchar2(128),
    deleted        char(1) default 'n' not null,
    info           varchar2(2000),
    params         clob,
    primary key(id)
  );

CREATE INDEX HarvestHistoryNDX1 ON HarvestHistory(harvestDate);

REM ======================================================================

CREATE TABLE Groups
  (
    id           int,
    name         varchar2(32)    not null,
    description  varchar2(255),
    email        varchar2(32),
    referrer     int,
    primary key(id),
    unique(name)
  );

REM ======================================================================

CREATE TABLE GroupsDes
  (
    idDes   int,
    langId  varchar2(5),
    label   varchar2(96)   not null,
    primary key(idDes,langId)
  );

REM ======================================================================

CREATE TABLE UserGroups
  (
    userId   int,
    groupId  int,
    primary key(userId,groupId)
  );

REM ======================================================================

CREATE TABLE CategoriesDes
  (
    idDes   int,
    langId  varchar2(5),
    label   varchar2(255)   not null,
    primary key(idDes,langId)
  );

REM ======================================================================

CREATE TABLE Metadata
  (
    id           int,
    uuid         varchar2(250)   not null,
    schemaId     varchar2(32)    not null,
    isTemplate   char(1)        default 'n' not null,
    isHarvested  char(1)        default 'n' not null,
    createDate   varchar2(30)    not null,
    changeDate   varchar2(30)    not null,
    data         clob           not null,
    source       varchar2(250)   not null,
    title        varchar2(255),
    root         varchar2(255),
    harvestUuid  varchar2(250)   default null,
    owner        int            not null,
    doctype      varchar2(255),
    groupOwner   int            default null,
    harvestUri   varchar2(255)   default null,
    rating       int            default 0 not null,
    popularity   int            default 0 not null,
    displayorder int,
    primary key(id),
    unique(uuid)
  );

CREATE TABLE Validation 
  (
    metadataId   int,
    valType      varchar2(40),
    status       int,
    tested       int,
    failed       int,
    valDate      varchar2(30),
    primary key(metadataId, valType)
);


REM ======================================================================

CREATE TABLE MetadataCateg
  (
    metadataId  int,
    categoryId  int,
    primary key(metadataId,categoryId)
  );

REM ======================================================================

CREATE TABLE StatusValues
  (
    id        int not null,
    name      varchar2(32)   not null,
    reserved  char(1)       default 'n' not null,
    primary key(id)
  );

REM ======================================================================

CREATE TABLE StatusValuesDes
  (
    idDes   int not null,
    langId  varchar2(5) not null,
    label   varchar2(96)   not null,
    primary key(idDes,langId)
  );

REM ======================================================================

CREATE TABLE MetadataStatus
  (
    metadataId  int not null,
    statusId    int default 0 not null,
    userId      int not null,
    changeDate   varchar2(30)    not null,
    changeMessage   varchar2(2048) not null,
    primary key(metadataId,statusId,userId,changeDate),
    foreign key(metadataId) references Metadata(id),
    foreign key(statusId)   references StatusValues(id),
    foreign key(userId)     references Users(id)
  );

REM ======================================================================

CREATE TABLE OperationAllowed
  (
    groupId      int,
    metadataId   int,
    operationId  int,
    primary key(groupId,metadataId,operationId)
  );

CREATE INDEX OperationAllowedNDX1 ON OperationAllowed(metadataId);

REM ======================================================================

CREATE TABLE MetadataRating
  (
    metadataId  int,
    ipAddress   varchar2(32),
    rating      int           not null,
    primary key(metadataId,ipAddress)
  );

REM ======================================================================

CREATE TABLE MetadataNotifiers
  (
    id         int,
    name       varchar2(32)    not null,
    url        varchar2(255)   not null,
    enabled    char(1)        default 'n' not null,
    username       varchar2(32),
    password       varchar2(32),
    primary key(id)
  );

REM ======================================================================

CREATE TABLE MetadataNotifications
  (
    metadataId         int,
    notifierId         int,
    notified           char(1)        default 'n' not null,
    metadataUuid       varchar2(250)   not null,
    action             char(1)        not null,
    errormsg           clob,
    primary key(metadataId,notifierId)
  );


REM ======================================================================

CREATE TABLE CswServerCapabilitiesInfo
  (
    idField   int,
    langId    varchar2(5)    not null,
    field     varchar2(32)   not null,
    label     clob,
    primary key(idField)
  );

REM ======================================================================

CREATE TABLE Thesaurus
  (
    id   varchar2(250),
    activated    varchar2(1),
    primary key(id)
  );

REM ======================================================================

CREATE TABLE spatialIndex
  (
		fid int,
    id  varchar2(250),
    the_geom SDO_GEOMETRY,
    primary key(fid)
  );

CREATE INDEX spatialIndexNDX1 ON spatialIndex(id);
DELETE FROM user_sdo_geom_metadata WHERE TABLE_NAME = 'SPATIALINDEX';
INSERT INTO user_sdo_geom_metadata (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) VALUES ( 'SPATIALINDEX', 'the_geom', SDO_DIM_ARRAY( SDO_DIM_ELEMENT('Longitude', -180, 180, 10), SDO_DIM_ELEMENT('Latitude', -90, 90, 10)), 8307);
CREATE INDEX spatialIndexNDX2 on spatialIndex(the_geom) INDEXTYPE IS MDSYS.SPATIAL_INDEX;

REM CREATE INDEX MetadataNDX1 ON Metadata(uuid);
CREATE INDEX MetadataNDX2 ON Metadata(source);
CREATE INDEX MetadataNDX3 ON Metadata(owner);

ALTER TABLE CategoriesDes ADD FOREIGN KEY (idDes) REFERENCES Categories (id);
ALTER TABLE CategoriesDes ADD FOREIGN KEY (langId) REFERENCES Languages (id);
ALTER TABLE Groups ADD FOREIGN KEY (referrer) REFERENCES Users (id);
ALTER TABLE GroupsDes ADD FOREIGN KEY (langId) REFERENCES Languages (id);
ALTER TABLE GroupsDes ADD FOREIGN KEY (idDes) REFERENCES Groups (id);
ALTER TABLE IsoLanguagesDes ADD FOREIGN KEY (langId) REFERENCES Languages (id);
ALTER TABLE IsoLanguagesDes ADD FOREIGN KEY (idDes) REFERENCES IsoLanguages (id);
ALTER TABLE Metadata ADD FOREIGN KEY (owner) REFERENCES Users (id);
ALTER TABLE Metadata ADD FOREIGN KEY (groupOwner) REFERENCES Groups (id);
ALTER TABLE Validation ADD FOREIGN KEY (metadataId) REFERENCES Metadata (id);
ALTER TABLE MetadataCateg ADD FOREIGN KEY (categoryId) REFERENCES Categories (id);
ALTER TABLE MetadataCateg ADD FOREIGN KEY (metadataId) REFERENCES Metadata (id);
ALTER TABLE MetadataRating ADD FOREIGN KEY (metadataId) REFERENCES Metadata (id);
ALTER TABLE OperationAllowed ADD FOREIGN KEY (operationId) REFERENCES Operations (id);
ALTER TABLE OperationAllowed ADD FOREIGN KEY (groupId) REFERENCES Groups (id);
ALTER TABLE OperationAllowed ADD FOREIGN KEY (metadataId) REFERENCES Metadata (id);
ALTER TABLE OperationsDes ADD FOREIGN KEY (langId) REFERENCES Languages (id);
ALTER TABLE OperationsDes ADD FOREIGN KEY (idDes) REFERENCES Operations (id);
ALTER TABLE RegionsDes ADD FOREIGN KEY (langId) REFERENCES Languages (id);
ALTER TABLE RegionsDes ADD FOREIGN KEY (idDes) REFERENCES Regions (id);
ALTER TABLE Settings ADD FOREIGN KEY (parentId) REFERENCES Settings (id);
ALTER TABLE UserGroups ADD FOREIGN KEY (userId) REFERENCES Users (id);
ALTER TABLE UserGroups ADD FOREIGN KEY (groupId) REFERENCES Groups (id);
ALTER TABLE MetadataNotifications ADD FOREIGN KEY (notifierId) REFERENCES MetadataNotifiers(id);
ALTER TABLE CswServerCapabilitiesInfo ADD FOREIGN KEY (langId) REFERENCES Languages (id);
