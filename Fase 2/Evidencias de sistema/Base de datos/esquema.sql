-- Esquema real de la base de datos del prototipo
-- Plataforma de apoyo al Modelo de Prevencion del Delito (MPD) — APT122 Grupo 7
-- Generado desde la base sembrada con drizzle-kit push

CREATE TABLE `account` (
	`id` text PRIMARY KEY NOT NULL,
	`issuer` text NOT NULL,
	`account_id` text NOT NULL,
	`provider_id` text NOT NULL,
	`user_id` text NOT NULL,
	`access_token` text,
	`refresh_token` text,
	`id_token` text,
	`access_token_expires_at` integer,
	`refresh_token_expires_at` integer,
	`scope` text,
	`password` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);

CREATE TABLE `alerta` (
	`id` text PRIMARY KEY NOT NULL,
	`evento_id` text NOT NULL,
	`control_id` text NOT NULL,
	`control_codigo` text NOT NULL,
	`control_version` integer NOT NULL,
	`definicion_snapshot` text NOT NULL,
	`score` real NOT NULL,
	`banda` text NOT NULL,
	`estado` text DEFAULT 'abierta' NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`evento_id`) REFERENCES `evento`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`control_id`) REFERENCES `control`(`id`) ON UPDATE no action ON DELETE no action
);

CREATE TABLE `alerta_senal` (
	`id` text PRIMARY KEY NOT NULL,
	`alerta_id` text NOT NULL,
	`senal_codigo` text NOT NULL,
	`disparo` integer NOT NULL,
	`peso` real NOT NULL,
	`contribucion` real NOT NULL,
	`detalle` text NOT NULL,
	`datos` text,
	`orden` integer DEFAULT 0 NOT NULL,
	FOREIGN KEY (`alerta_id`) REFERENCES `alerta`(`id`) ON UPDATE no action ON DELETE cascade
);

CREATE TABLE `caso` (
	`id` text PRIMARY KEY NOT NULL,
	`alerta_id` text NOT NULL,
	`delito` text NOT NULL,
	`resumen` text NOT NULL,
	`abierto_por` text NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`alerta_id`) REFERENCES `alerta`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`abierto_por`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);

CREATE TABLE `control` (
	`id` text PRIMARY KEY NOT NULL,
	`codigo` text NOT NULL,
	`nombre` text NOT NULL,
	`descripcion` text,
	`delito` text NOT NULL,
	`tipo_evento` text NOT NULL,
	`umbral_alerta` real NOT NULL,
	`umbral_media` real NOT NULL,
	`umbral_alta` real NOT NULL,
	`parametros` text DEFAULT '{}' NOT NULL,
	`version` integer DEFAULT 1 NOT NULL,
	`activo` integer DEFAULT true NOT NULL,
	`autorado_por` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`autorado_por`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);

CREATE TABLE `control_senal` (
	`control_id` text NOT NULL,
	`senal_codigo` text NOT NULL,
	`peso` real NOT NULL,
	`orden` integer DEFAULT 0 NOT NULL,
	PRIMARY KEY(`control_id`, `senal_codigo`),
	FOREIGN KEY (`control_id`) REFERENCES `control`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`senal_codigo`) REFERENCES `senal`(`codigo`) ON UPDATE no action ON DELETE no action
);

CREATE TABLE `evento` (
	`id` text PRIMARY KEY NOT NULL,
	`tipo` text NOT NULL,
	`fecha` integer NOT NULL,
	`monto` real NOT NULL,
	`proveedor_rut` text,
	`solicitante_rut` text,
	`aprobador_rut` text,
	`datos` text DEFAULT '{}' NOT NULL,
	`fila_original` text,
	`lote_id` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`proveedor_rut`) REFERENCES `proveedor`(`rut`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`solicitante_rut`) REFERENCES `persona`(`rut`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`aprobador_rut`) REFERENCES `persona`(`rut`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`lote_id`) REFERENCES `lote_ingesta`(`id`) ON UPDATE no action ON DELETE no action
);

CREATE TABLE `lote_ingesta` (
	`id` text PRIMARY KEY NOT NULL,
	`nombre_archivo` text NOT NULL,
	`filas_leidas` integer NOT NULL,
	`filas_aceptadas` integer NOT NULL,
	`actor_id` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`actor_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);

CREATE TABLE `persona` (
	`rut` text PRIMARY KEY NOT NULL,
	`nombres` text NOT NULL,
	`apellido_paterno` text NOT NULL,
	`apellido_materno` text,
	`cargo` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);

CREATE TABLE `proveedor` (
	`rut` text PRIMARY KEY NOT NULL,
	`razon_social` text NOT NULL,
	`fecha_constitucion` integer,
	`flag_pep` integer DEFAULT false NOT NULL,
	`causas_judiciales` integer DEFAULT 0 NOT NULL,
	`enriquecido_en` integer,
	`enriquecido_desde` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);

CREATE TABLE `revision` (
	`id` text PRIMARY KEY NOT NULL,
	`alerta_id` text NOT NULL,
	`accion` text NOT NULL,
	`justificacion` text,
	`actor_id` text NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	FOREIGN KEY (`alerta_id`) REFERENCES `alerta`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`actor_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);

CREATE TABLE `senal` (
	`codigo` text PRIMARY KEY NOT NULL,
	`nombre` text NOT NULL,
	`descripcion` text NOT NULL,
	`familia` text NOT NULL,
	`lee` text NOT NULL,
	`tipo_evento` text NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);

CREATE TABLE `session` (
	`id` text PRIMARY KEY NOT NULL,
	`expires_at` integer NOT NULL,
	`token` text NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer NOT NULL,
	`ip_address` text,
	`user_agent` text,
	`user_id` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);

CREATE TABLE `user` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`email_verified` integer DEFAULT false NOT NULL,
	`image` text,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);

CREATE TABLE `verification` (
	`id` text PRIMARY KEY NOT NULL,
	`identifier` text NOT NULL,
	`value` text NOT NULL,
	`expires_at` integer NOT NULL,
	`created_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL,
	`updated_at` integer DEFAULT (cast(unixepoch('subsecond') * 1000 as integer)) NOT NULL
);

CREATE UNIQUE INDEX `account_issuer_accountId_uidx` ON `account` (`issuer`,`account_id`);

CREATE INDEX `account_userId_idx` ON `account` (`user_id`);

CREATE INDEX `alerta_banda_idx` ON `alerta` (`banda`);

CREATE INDEX `alerta_control_idx` ON `alerta` (`control_id`);

CREATE INDEX `alerta_estado_idx` ON `alerta` (`estado`);

CREATE INDEX `alerta_evento_idx` ON `alerta` (`evento_id`);

CREATE INDEX `alerta_senal_alerta_idx` ON `alerta_senal` (`alerta_id`);

CREATE INDEX `alerta_senal_codigo_idx` ON `alerta_senal` (`senal_codigo`);

CREATE INDEX `caso_alerta_idx` ON `caso` (`alerta_id`);

CREATE INDEX `control_activo_idx` ON `control` (`activo`);

CREATE UNIQUE INDEX `control_codigo_unique` ON `control` (`codigo`);

CREATE INDEX `control_delito_idx` ON `control` (`delito`);

CREATE INDEX `evento_lote_idx` ON `evento` (`lote_id`);

CREATE INDEX `evento_proveedor_idx` ON `evento` (`proveedor_rut`);

CREATE INDEX `evento_tipo_fecha_idx` ON `evento` (`tipo`,`fecha`);

CREATE INDEX `lote_ingesta_created_idx` ON `lote_ingesta` (`created_at`);

CREATE INDEX `revision_actor_idx` ON `revision` (`actor_id`);

CREATE INDEX `revision_alerta_idx` ON `revision` (`alerta_id`);

CREATE UNIQUE INDEX `session_token_unique` ON `session` (`token`);

CREATE INDEX `session_userId_idx` ON `session` (`user_id`);

CREATE UNIQUE INDEX `user_email_unique` ON `user` (`email`);

CREATE INDEX `verification_identifier_idx` ON `verification` (`identifier`);
