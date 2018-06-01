DROP USER reader1;
DROP USER reader2;
DROP USER writer1;
DROP USER writer2;

DROP GROUP readers;
DROP GROUP writers;

CREATE GROUP readers;
CREATE GROUP writers;

CREATE USER reader1 WITH PASSWORD 'reader1' NOCREATEDB NOCREATEUSER;
CREATE USER reader2 WITH PASSWORD 'reader2' NOCREATEDB NOCREATEUSER;

CREATE USER writer1 WITH PASSWORD 'writer1' NOCREATEDB NOCREATEUSER;
CREATE USER writer2 WITH PASSWORD 'writer2' NOCREATEDB NOCREATEUSER;

ALTER GROUP readers ADD USER reader1, reader2;
ALTER GROUP writers ADD USER writer1, writer2;

DROP TRIGGER ASSIGN_DUTY_PLANES ON "Planes";
DROP FUNCTION assign_duty();
DROP TRIGGER ASSIGN_ORDER ON "Orders";
DROP FUNCTION assign_order();
DROP FUNCTION is_in_zone(decimal, decimal);

DROP VIEW available_resources;
DROP VIEW unwatched_zones;
DROP VIEW detailed_order;

ALTER TABLE "Planes" DROP CONSTRAINT "Planes_fk0";
ALTER TABLE "Planes" DROP CONSTRAINT "Planes_fk1";
ALTER TABLE "Planes" DROP CONSTRAINT "Planes_fk2";
ALTER TABLE "Planes" DROP CONSTRAINT "Planes_fk3";
ALTER TABLE "Pilots" DROP CONSTRAINT "Pilots_fk0";
ALTER TABLE "Pilots" DROP CONSTRAINT "Pilots_fk1";
ALTER TABLE "Orders" DROP CONSTRAINT "Orders_fk1";
ALTER TABLE "Orders" DROP CONSTRAINT "Orders_fk2";
ALTER TABLE "Applicable_weapons" DROP CONSTRAINT "Applicable_weapons_fk0";
ALTER TABLE "Applicable_weapons" DROP CONSTRAINT "Applicable_weapons_fk1";

DROP TABLE "Planes";
DROP TABLE "Pilots";
DROP TABLE "Models";
DROP TABLE "Statuses";
DROP TABLE "Orders";
DROP TABLE "Zones";
DROP TABLE "Weapons";
DROP TABLE "Targets";
DROP TABLE "Applicable_weapons";

CREATE TABLE "Planes" (
	"plane_id" serial NOT NULL,
	"model_id" integer NOT NULL,
	"pilot_id" integer NOT NULL UNIQUE,
	"duty_id" integer,
	"fuel" DECIMAL NOT NULL CHECK (fuel > 0 AND fuel < 1),
	"status_id" integer NOT NULL,
	"weapon_id" integer NOT NULL,
	"x" DECIMAL DEFAULT 0.0,
	"y" DECIMAL DEFAULT 0.0,
	"z" DECIMAL DEFAULT 0.0,
	CONSTRAINT Planes_pk PRIMARY KEY ("plane_id")
);



CREATE TABLE "Pilots" (
	"pilot_id" serial NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"surname" VARCHAR(255) NOT NULL,
	"status_id" integer NOT NULL,
    "order_id" integer,
	CONSTRAINT Pilots_pk PRIMARY KEY ("pilot_id")
);



CREATE TABLE "Models" (
	"model_id" serial NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"max_fuel" DECIMAL NOT NULL,
	"fuel_consumption" DECIMAL NOT NULL,
    "speed" DECIMAL NOT NULL CHECK (speed > 0),
	CONSTRAINT Models_pk PRIMARY KEY ("model_id")
);



CREATE TABLE "Statuses" (
	"status_id" serial NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"description" VARCHAR(255) NOT NULL,
	CONSTRAINT Statuses_pk PRIMARY KEY ("status_id")
);



CREATE TABLE "Orders" (
	"order_id" serial NOT NULL,
	"target_id" integer NOT NULL UNIQUE,
    "zone_id" integer,
	"duty_time" decimal NOT NULL CHECK (duty_time > 0),
	"status_id" integer,
	CONSTRAINT Orders_pk PRIMARY KEY ("order_id")
);



CREATE TABLE "Zones" (
	"zone_id" serial NOT NULL,
	"x" DECIMAL NOT NULL,
	"y" DECIMAL NOT NULL,
	"a" DECIMAL NOT NULL CHECK (a > 0),
	"b" DECIMAL NOT NULL CHECK (b > 0),
	CONSTRAINT Zones_pk PRIMARY KEY ("zone_id")
);



CREATE TABLE "Weapons" (
	"weapon_id" serial NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	CONSTRAINT Weapons_pk PRIMARY KEY ("weapon_id")
);



CREATE TABLE "Targets" (
	"target_id" serial NOT NULL,
	"name" VARCHAR(255) NOT NULL,
	"x" DECIMAL NOT NULL,
	"y" DECIMAL NOT NULL,
	"z" DECIMAL NOT NULL,
	CONSTRAINT Targets_pk PRIMARY KEY ("target_id")
);



CREATE TABLE "Applicable_weapons" (
	"weapon_id" integer NOT NULL,
	"target_id" integer NOT NULL
);



ALTER TABLE "Planes" ADD CONSTRAINT "Planes_fk0" FOREIGN KEY ("model_id") REFERENCES "Models"("model_id");
ALTER TABLE "Planes" ADD CONSTRAINT "Planes_fk1" FOREIGN KEY ("pilot_id") REFERENCES "Pilots"("pilot_id");
ALTER TABLE "Planes" ADD CONSTRAINT "Planes_fk2" FOREIGN KEY ("status_id") REFERENCES "Statuses"("status_id");
ALTER TABLE "Planes" ADD CONSTRAINT "Planes_fk3" FOREIGN KEY ("weapon_id") REFERENCES "Weapons"("weapon_id");

ALTER TABLE "Pilots" ADD CONSTRAINT "Pilots_fk0" FOREIGN KEY ("status_id") REFERENCES "Statuses"("status_id");
ALTER TABLE "Pilots" ADD CONSTRAINT "Pilots_fk1" FOREIGN KEY ("order_id") REFERENCES "Orders"("order_id");

ALTER TABLE "Orders" ADD CONSTRAINT "Orders_fk0" FOREIGN KEY ("target_id") REFERENCES "Targets"("target_id");
ALTER TABLE "Orders" ADD CONSTRAINT "Orders_fk1" FOREIGN KEY ("status_id") REFERENCES "Statuses"("status_id");
ALTER TABLE "Orders" ADD CONSTRAINT "Orders_fk2" FOREIGN KEY ("zone_id") REFERENCES "Zones"("zone_id");

ALTER TABLE "Applicable_weapons" ADD CONSTRAINT "Applicable_weapons_fk0" FOREIGN KEY ("weapon_id") REFERENCES "Weapons"("weapon_id");
ALTER TABLE "Applicable_weapons" ADD CONSTRAINT "Applicable_weapons_fk1" FOREIGN KEY ("target_id") REFERENCES "Targets"("target_id");

-- Sample Data

INSERT INTO "Statuses" (name, description) VALUES ('ГОТОВ', 'Пилот готов к выполнеию поручений');
INSERT INTO "Statuses" (name, description) VALUES ('БОЛЕН', 'Пилот на больничном');
INSERT INTO "Statuses" (name, description) VALUES ('В ОТПУСКЕ', 'Пилот в данный момент находится в отпуске');
INSERT INTO "Statuses" (name, description) VALUES ('ВЫПОЛНЕНИЕ', 'Пилот выполняет поставленную задачу');
INSERT INTO "Statuses" (name, description) VALUES ('ПОЛЁТ', 'Перехватчик находится в воздухе');
INSERT INTO "Statuses" (name, description) VALUES ('НА БАЗЕ', 'Перехватчик находится на авиабазе');
INSERT INTO "Statuses" (name, description) VALUES ('СЛОМАН', 'Перехватчик сломан');
INSERT INTO "Statuses" (name, description) VALUES ('ВЫПОЛНЯЕТСЯ', 'Задача выпоняется');
INSERT INTO "Statuses" (name, description) VALUES ('НЕ НАЗНАЧЕНА', 'Задача не назначена');

INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Решетов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Травин', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Романов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Замятин', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Макаров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Травин', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Решетов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Макаров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Казанский', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Субботин', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Волков', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Александров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Сидоров', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Сидоров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Сидоров', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Травин', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Замятин', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Сидоров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Замятин', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Романов', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Макаров', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Субботин', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Казанский', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Казанский', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Казанский', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Волков', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Решетов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Филимонов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Решетов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Макаров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Иванов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Субботин', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Александров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Макаров', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Сидоров', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Субботин', 2);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Александров', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Илья', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Субботин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Виктор', 'Решетов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Казанский', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Иванов', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Александр', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Дмитрий', 'Макаров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Ярослав', 'Травин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Андрей', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Волков', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Сергей', 'Филимонов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Замятин', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Роман', 'Замятин', 3);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Решетов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Казанский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владимир', 'Иванов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Константин', 'Сидоров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Глеб', 'Романов', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Владислав', 'Александров', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Богдан', 'Иванов', 1);

INSERT INTO "Weapons" (name) VALUES ('Х-31');
INSERT INTO "Weapons" (name) VALUES ('Х-35');
INSERT INTO "Weapons" (name) VALUES ('Х-38');
INSERT INTO "Weapons" (name) VALUES ('Х-58');

INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', 245.12, 314.3, 50.45);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', 390.64, 141.42, 105.21);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', 671.31, 502.4, 76.72);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', 661.22, 512.4, 75.41);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '243.03', '395.97', 89.54);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '683.13', '22.07', 81.1);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '118.75', '99.77', 23.77);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '283.28', '145.96', 80.2);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '431.21', '442.94', 73.44);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '938.25', '460.56', 46.69);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '721.58', '866.9', 44.28);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '506.41', '314.2', 63.88);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '275.88', '633.16', 59.34);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '596.71', '272.33', 86.98);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', 1090.76, 1132.49, 32.85);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '131.38', '349.99', 92.2);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '373.19', '527.48', 37.26);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '470.09', '128.35', 32.61);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '539.05', '560.25', 54.49);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '406.93', '594.12', 31.76);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '327.71', '808.38', 40.44);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '775.41', '947.78', 87.23);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '265.34', '281.59', 19.48);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '131.75', '675.08', 51.98);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '208.1', '56.28', 21.26);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '739.71', '333.1', 52.29);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '948.74', '141.2', 47.85);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '220.93', '106.24', 81.14);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '803.59', '304.89', 53.05);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '18.72', '529.13', 51.28);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '12.39', '908.43', 47.84);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '908.63', '344.19', 52.36);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '846.57', '283.96', 90.49);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '250.17', '442.49', 29.93);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '113.86', '505', 42.4);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '683.56', '596.71', 54.49);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '423.51', '692.85', 28.12);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '166.39', '884.26', 74.55);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '94.24', '622.16', 52.41);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '92.2', '428.6', 29.33);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '10.56', '975.56', 24.8);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '63.72', '481.64', 59.73);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '849.94', '655.57', 19.1);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '482.82', '614.74', 89.27);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '546.77', '326.06', 42.49);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '122.61', '627.9', 54.59);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '472.23', '700.14', 69.21);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '764.84', '941.77', 60.76);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-16', '928.9', '226.66', 33.76);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-15', '967.22', '308.22', 25.79);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-35', '165.05', '741.45', 29.92);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '159.2', '675.89', 7.66);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '266.55', '959.35', 70.98);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '205.63', '31.05', 76.8);
INSERT INTO "Targets" (name, x, y, z) VALUES ('F-18', '369.82', '632.6', 85.21);

INSERT INTO "Models" (name, max_fuel, fuel_consumption, speed) VALUES ('Миг-31', '600.0', '100.42', '2700.0');
INSERT INTO "Models" (name, max_fuel, fuel_consumption, speed) VALUES ('Миг-29', '589.0', '121.7', '3000.0');
INSERT INTO "Models" (name, max_fuel, fuel_consumption, speed) VALUES ('Су-32', '702.0', '59.63', '2500.0');

INSERT INTO "Zones" (x, y, a, b) VALUES (50.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (150.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (250.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (350.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (450.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (550.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (650.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (750.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (850.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (950.0, 50.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (50.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (150.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (250.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (350.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (450.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (550.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (650.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (750.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (850.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (950.0, 250.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (50.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (150.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (250.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (350.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (450.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (550.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (650.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (750.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (850.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (950.0, 450.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (50.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (150.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (250.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (350.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (450.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (550.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (650.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (750.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (850.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (950.0, 650.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (50.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (150.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (250.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (350.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (450.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (550.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (650.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (750.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (850.0, 850.0, 50.0, 50.0);
INSERT INTO "Zones" (x, y, a, b) VALUES (950.0, 850.0, 50.0, 50.0);

INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 2);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 45);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 43);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 28);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 31);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 17);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 26);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 23);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 6);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 31);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 47);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 12);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 25);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 48);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 10);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 51);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 36);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 27);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 9);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 2);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 38);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 36);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 19);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 12);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 51);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 32);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 44);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 39);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 44);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 43);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 18);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 11);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 14);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 23);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 1);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 19);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 25);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 42);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 18);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 46);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 20);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 29);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 24);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 9);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 39);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 19);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 24);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 42);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 3);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 10);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 43);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 18);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 49);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 44);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 6);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 35);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 35);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 29);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 23);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 16);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 16);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 13);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 37);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 13);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 6);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 26);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 48);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 45);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 41);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 50);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 53);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 6);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 15);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 12);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 8);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 17);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 15);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 45);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 5);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 27);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 10);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 4);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 47);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 51);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 1);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 51);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 38);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 50);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 50);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 53);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 1);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 37);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 3);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 8);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 1);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 12);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 26);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 40);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 7);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 40);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 42);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 45);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 21);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 41);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 34);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 18);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 49);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 29);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 39);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 11);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 38);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 37);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 53);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 7);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 33);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 34);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 53);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 27);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 36);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 42);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 3);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 34);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 40);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 29);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 46);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 41);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 33);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 30);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 5);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 30);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 28);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 34);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 49);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 8);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 49);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 35);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 13);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 28);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 52);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 15);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 20);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 9);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 14);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 14);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 5);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 19);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 7);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 11);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 24);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 47);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 48);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 8);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 3);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 21);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 24);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 22);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 33);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 22);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 52);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 40);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 31);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 39);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 21);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 37);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 33);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 20);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 15);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 46);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 35);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 27);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 28);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 2);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 22);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 17);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 44);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 41);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 38);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 47);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 10);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 25);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 4);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 32);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 9);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 32);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 5);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 17);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 4);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 26);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 50);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 13);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 4);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 22);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 30);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 21);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 20);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 46);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 36);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 7);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 31);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (1, 52);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 48);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 30);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 16);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 14);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 23);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 52);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 11);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 32);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (3, 43);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 2);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (4, 16);
INSERT INTO "Applicable_weapons" (weapon_id, target_id) VALUES (2, 25);


-- Functions

CREATE FUNCTION is_in_zone(decimal, decimal) RETURNS integer AS '
DECLARE
    result integer;
BEGIN
    SELECT zone_id INTO result FROM "Zones" zone where ($1 < zone.x + a)
    AND (zone.x - a < $1)
    AND ($2 < zone.y + b)
    AND (zone.y - b < $2);
    RETURN result;
END;
' LANGUAGE plpgsql;

-- Triggers

CREATE FUNCTION assign_duty() RETURNS trigger AS '
DECLARE
    duty_fuel_sum decimal;
    rest_fuel_sum decimal;
BEGIN
    SELECT COALESCE(SUM(fuel), 0) into duty_fuel_sum FROM "Planes" where duty_id = 1;
    SELECT COALESCE(SUM(fuel), 0) into rest_fuel_sum FROM "Planes" where duty_id = 2;
    IF (duty_fuel_sum > rest_fuel_sum) OR (NEW.status_id = 7) THEN
        NEW.duty_id = 2;
    ELSE
        NEW.duty_id = 1;
    END IF;
    RETURN NEW;
END;' LANGUAGE plpgsql;

CREATE TRIGGER ASSIGN_DUTY_PLANES BEFORE INSERT ON "Planes" FOR EACH ROW EXECUTE PROCEDURE assign_duty();


CREATE FUNCTION assign_order() RETURNS trigger AS '
DECLARE
    zone integer;
    assignee integer;
BEGIN
    SELECT is_in_zone(t.x, t.y) into zone FROM "Targets" t WHERE NEW.target_id = t.target_id;
    NEW.zone_id = zone;

    IF zone IS NOT NULL THEN
        SELECT pln.pilot_id into assignee FROM "Planes" pln, "Models" mdl, "Weapons" wp, "Applicable_weapons" awp, "Pilots" plt,
        "Targets" trg, "Zones" zn
        WHERE pln.weapon_id = awp.weapon_id
        AND awp.target_id = NEW.target_id
        AND trg.target_id = NEW.target_id
        AND zn.zone_id = zone
        AND pln.model_id = mdl.model_id
		AND plt.status_id = 1 /* ГОТОВ */
		AND pln.pilot_id = plt.pilot_id
        AND mdl.max_fuel * pln.fuel / mdl.fuel_consumption - (NEW.duty_time + (sqrt(pow(zn.x, 2) + pow(zn.y, 2) + pow(pln.z, 2)) + sqrt(pow(pln.x - trg.x, 2) + pow(pln.y - trg.y, 2) + pow(pln.z - trg.z, 2))) / mdl.speed) >= 0
        ORDER BY (mdl.max_fuel * pln.fuel / mdl.fuel_consumption - (NEW.duty_time + (sqrt(pow(zn.x, 2) + pow(zn.y, 2) + pow(pln.z, 2)) + sqrt(pow(pln.x - trg.x, 2) + pow(pln.y - trg.y, 2) + pow(pln.z - trg.z, 2))) / mdl.speed)) DESC
        LIMIT 1;

        UPDATE "Pilots" set order_id = NEW.order_id WHERE pilot_id = assignee;
        UPDATE "Pilots" set status_id = 4 /* ВЫПОЛНЕНИЕ */ WHERE pilot_id = assignee;
		NEW.status_id := 8 /* ВЫПОЛНЯЕТСЯ */;
        RETURN NEW;
    ELSE
        NEW.status_id := 9 /* НЕ НАЗНАЧЕНА */;
        RETURN NEW;
    END IF;
END;' LANGUAGE plpgsql;

CREATE TRIGGER ASSIGN_ORDER BEFORE INSERT ON "Orders" FOR EACH ROW EXECUTE PROCEDURE assign_order();

-- Views
CREATE VIEW available_resources AS
SELECT model.name as "Перехватчик", plane.fuel as "Топливо", pilot.surname || ' ' || pilot.name as "Пилот", weapon.name as "Оружие" FROM "Planes" plane, "Pilots" pilot, "Models" model, "Weapons" weapon
    WHERE plane.duty_id = 1
    AND plane.status_id IN (5, 6) /* НА БАЗЕ, ПОЛЁТ */
    AND pilot.status_id IN (1, 4) /* ГОТОВ, ВЫПОЛНЕНИЕ */
    AND plane.pilot_id = pilot.pilot_id
    AND plane.weapon_id = weapon.weapon_id
    AND plane.model_id = model.model_id;

CREATE VIEW unwatched_zones AS
SELECT zone_id as "Номер", 2*a || ' X ' || 2*b as "Размер", 'X: ' || x || ', Y:' || y as "Координаты"  FROM "Zones"
	WHERE zone_id NOT IN (SELECT zone_id FROM "Orders");

CREATE VIEW detailed_order AS
SELECT o.order_id as "Приказ #", o.zone_id as "Зона #", p.surname || ' ' ||
p.name as "Пилот", s.name as "Статус"
	FROM "Orders" o, "Pilots" p, "Statuses" s
	WHERE p.order_id = o.order_id
	AND s.status_id = p.status_id;

-- Grants
GRANT SELECT ON TABLE "Planes" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Planes" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Planes_plane_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Pilots" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Pilots" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Pilots_pilot_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Models" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Models" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Models_model_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Statuses" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Statuses" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Statuses_status_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Orders" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Orders" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Orders_order_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Zones" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Zones" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Zones_zone_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Weapons" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Weapons" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Weapons_weapon_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Targets" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Targets" TO GROUP writers;
GRANT SELECT, UPDATE ON TABLE "Targets_target_id_seq" TO GROUP writers;

GRANT SELECT ON TABLE "Applicable_weapons" TO GROUP readers;
GRANT INSERT, UPDATE, DELETE ON TABLE "Applicable_weapons" TO GROUP writers;


-- Inserting Planes
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 49, 0.36, 6, 1, 311.47, 358.86, 96.71);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 63, 0.61, 6, 4, 580.02, 818.31, 44.02);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 149, 0.93, 5, 4, 585.5, 484.69, 92.8);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 14, 0.32, 5, 2, 246.88, 294.22, 10.88);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 15, 0.25, 5, 2, 913.94, 702.54, 8.95);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 129, 0.78, 6, 3, 187.28, 163.11, 99.55);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 36, 0.39, 6, 3, 736.47, 25.27, 83.69);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 53, 0.05, 5, 1, 182.82, 6.94, 59.82);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 45, 0.6, 6, 3, 275.61, 704.1, 57.68);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 91, 0.39, 6, 1, 697.21, 656.56, 28.2);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 135, 0.77, 6, 1, 455.05, 134.79, 10.5);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 152, 0.07, 5, 3, 221.92, 40.9, 38.55);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 89, 0.4, 5, 3, 750.8, 855.64, 67.22);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 7, 0.09, 5, 1, 832.16, 275.9, 98.38);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 30, 0.05, 6, 4, 874.58, 14.81, 56.02);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 97, 0.2, 5, 4, 291.71, 121.94, 55.84);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 90, 0.64, 5, 3, 905.37, 721.25, 87.64);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 12, 0.54, 6, 4, 577.76, 88.05, 46.9);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 32, 0.15, 6, 2, 347.29, 231.12, 50.13);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 142, 0.71, 6, 3, 986.66, 576.49, 29.39);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 98, 0.43, 5, 1, 964.28, 528.57, 48.92);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 62, 0.85, 5, 3, 781.8, 907.12, 63.67);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 46, 0.56, 5, 4, 712.72, 352.47, 17.41);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 28, 0.47, 5, 2, 688.95, 918.96, 90.76);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 17, 0.88, 5, 2, 166.2, 495.58, 72.97);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 131, 0.44, 6, 3, 19.58, 551.1, 8.07);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 146, 0.18, 6, 4, 852.57, 284.22, 98.08);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 94, 0.44, 6, 1, 95.82, 886.72, 99.34);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 96, 0.57, 5, 3, 328.18, 847.02, 12.57);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 159, 0.35, 5, 4, 962, 426.43, 75.99);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 26, 0.78, 6, 1, 79.61, 346.63, 20.82);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 92, 0.56, 6, 2, 224.93, 370.4, 35.04);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 110, 0.13, 5, 1, 72.42, 353.56, 68.12);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 78, 0.14, 6, 4, 614.83, 641.86, 64.91);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 34, 0.86, 6, 1, 578.13, 961.95, 91.3);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 47, 0.88, 6, 4, 278, 819.49, 74.61);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 140, 0.82, 6, 4, 110.9, 625.94, 23.42);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 38, 0.76, 6, 3, 392.43, 186.69, 0.63);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 54, 0.73, 5, 2, 695.03, 646.55, 50.67);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 40, 0.44, 5, 2, 670.76, 572.47, 41.99);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 155, 0.31, 5, 4, 417.14, 683.65, 29.61);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 150, 0.55, 6, 4, 230.7, 35.07, 60.6);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 157, 0.05, 6, 1, 593.92, 528.93, 72.42);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 35, 0.84, 5, 4, 983.17, 645.41, 34.76);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 151, 0.58, 6, 2, 45.38, 92.12, 46.5);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 27, 0.52, 6, 4, 561.28, 116.62, 17.03);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 82, 0.6, 6, 4, 155.9, 626.99, 8.27);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 55, 0.34, 5, 1, 148.47, 505.04, 85.42);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 37, 0.47, 5, 3, 816.04, 528.97, 23.59);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 20, 0.67, 6, 4, 893.32, 667.3, 12.53);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 101, 0.47, 5, 2, 445.01, 624.08, 56.73);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 133, 0.38, 6, 1, 470.6, 584.58, 22.62);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 21, 0.66, 6, 2, 355.11, 849.88, 36.31);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 42, 0.93, 5, 4, 339.02, 512.59, 66.04);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 22, 0.66, 6, 4, 636.05, 774.89, 12.05);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 74, 0.27, 5, 4, 788.17, 568.78, 6.36);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 86, 0.33, 6, 2, 429.28, 367.37, 56.46);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 19, 0.43, 6, 1, 44.97, 133.41, 38.18);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 51, 0.25, 6, 2, 410.42, 822.69, 78.3);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 67, 0.66, 5, 1, 818.62, 895.04, 18.74);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 141, 0.13, 5, 3, 463.9, 800.61, 68.17);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 100, 0.03, 6, 4, 663.58, 84.8, 54.14);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 106, 0.98, 6, 2, 219.01, 828.99, 59.82);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 59, 0.83, 5, 2, 458.21, 110.89, 8.27);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 66, 0.83, 5, 2, 636.28, 48.58, 24.12);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 1, 0.17, 6, 2, 109.59, 269.39, 46.52);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 84, 0.2, 5, 2, 101.74, 800.32, 85.5);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 73, 0.17, 5, 1, 773.51, 662.51, 43.1);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 99, 0.38, 5, 4, 489.76, 953.91, 41.02);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 134, 0.92, 5, 2, 224.67, 110.44, 87.41);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 4, 0.67, 6, 4, 43.53, 574.33, 82.48);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 153, 0.27, 6, 2, 985.14, 648.58, 95.37);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 5, 0.17, 5, 4, 632.35, 646.58, 30.52);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 81, 0.09, 5, 2, 469.97, 372.11, 23.1);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (3, 10, 0.89, 6, 3, 22.97, 346.32, 76.36);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 111, 0.05, 6, 3, 861.74, 360.06, 61.14);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (1, 148, 0.85, 5, 4, 177.23, 613.53, 67.76);
INSERT INTO "Planes" (model_id, pilot_id, fuel, status_id, weapon_id, x, y, z) VALUES (2, 137, 0.17, 5, 3, 397.84, 843.76, 12.98);

\echo Available resources:
SELECT * FROM available_resources;

\echo Unwatched zones:
SELECT * FROM unwatched_zones;

\echo Inserting orders
INSERT INTO "Orders" (target_id, duty_time) VALUES (10, 2.3);
INSERT INTO "Orders" (target_id, duty_time) VALUES (15, 1000.3);

\echo Detailed Orders:
SELECT * FROM detailed_order;

\echo Login as reader1
\c test reader1

\echo Weapons applicable for target:
SELECT wp.weapon_id as "Номер", wp.name as "Оружие", trg.name as "Цель"  FROM "Weapons" wp, "Applicable_weapons" awp, "Targets" trg
WHERE wp.weapon_id = awp.weapon_id
AND awp.target_id = trg.target_id
AND trg.target_id = 15;

\echo On duty:
SELECT plt.surname || ' ' || plt.name as "Пилот", mdl.name as "Перехватчик", mdl.max_fuel * pln.fuel as "Топливо"
FROM "Pilots" plt, "Planes" pln, "Models" mdl
WHERE pln.duty_id = 1
AND plt.pilot_id = pln.pilot_id
AND pln.model_id = mdl.model_id;

\echo Pilots:
SELECT plt.surname || ' ' || plt.name as "Пилот" FROM "Pilots" plt WHERE order_id IS NOT NULL AND status_id IN (1, 4);

\echo Inserting pilots:
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Каминский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Василий', 'Светличный', 2);

\echo Login as writer1
\c test writer1

\echo Weapons applicable for target:
SELECT wp.weapon_id as "Номер", wp.name as "Оружие", trg.name as "Цель"  FROM "Weapons" wp, "Applicable_weapons" awp, "Targets" trg
WHERE wp.weapon_id = awp.weapon_id
AND awp.target_id = trg.target_id
AND trg.target_id = 15;

\echo On duty:
SELECT plt.surname || ' ' || plt.name as "Пилот", mdl.name as "Перехватчик", mdl.max_fuel * pln.fuel as "Топливо"
FROM "Pilots" plt, "Planes" pln, "Models" mdl
WHERE pln.duty_id = 1
AND plt.pilot_id = pln.pilot_id
AND pln.model_id = mdl.model_id;

\echo Pilots:
SELECT plt.surname || ' ' || plt.name as "Пилот" FROM "Pilots" plt WHERE order_id IS NOT NULL AND status_id IN (1, 4);

\echo Inserting pilots:
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Олег', 'Каминский', 1);
INSERT INTO "Pilots" (name, surname, status_id) VALUES ('Василий', 'Светличный', 2);
