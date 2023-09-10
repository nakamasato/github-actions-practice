CREATE TABLE "users" (
  "id" bigint,
  "name" varchar NOT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "repos" (
  "id" bigint,
  "name" varchar NOT NULL,
  "owner_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "owner_id" FOREIGN KEY ("owner_id") REFERENCES "users" ("id")
);
