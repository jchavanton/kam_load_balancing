CREATE TABLE version (
	table_name character varying(32) NOT NULL PRIMARY KEY,
	table_version integer DEFAULT 0 NOT NULL
);

INSERT INTO "version" VALUES('dispatcher',4);
CREATE TABLE dispatcher (
	id INTEGER PRIMARY KEY NOT NULL,
	setid INTEGER DEFAULT 0 NOT NULL,
	destination VARCHAR(192) DEFAULT '' NOT NULL,
	flags INTEGER DEFAULT 0 NOT NULL,
	priority INTEGER DEFAULT 0 NOT NULL,
	attrs VARCHAR(128) DEFAULT '' NOT NULL,
	description VARCHAR(64) DEFAULT '' NOT NULL
);
INSERT INTO "dispatcher" VALUES(1,1,'sip:14.75.69.51:5072',0,12,'weight=50;rweight=50','');
INSERT INTO "dispatcher" VALUES(2,1,'sip:14.75.88.181:5072',0,12,'weight=50;rweight=50','');
INSERT INTO "dispatcher" VALUES(3,1,'sip:14.75.88.181:5073',0,12,'weight=50;rweight=50','');
INSERT INTO "dispatcher" VALUES(4,1,'sip:14.75.69.51:5073',0,12,'weight=50;rweight=50','');
CREATE INDEX version_table_name_idx ON version (table_name);
COMMIT;
