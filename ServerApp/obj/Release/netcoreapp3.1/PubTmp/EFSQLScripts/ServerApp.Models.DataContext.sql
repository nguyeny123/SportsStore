IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210816123718_Initial')
BEGIN
    CREATE TABLE [Suppliers] (
        [SupplierId] bigint NOT NULL IDENTITY,
        [Name] nvarchar(max) NULL,
        [City] nvarchar(max) NULL,
        [State] nvarchar(max) NULL,
        CONSTRAINT [PK_Suppliers] PRIMARY KEY ([SupplierId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210816123718_Initial')
BEGIN
    CREATE TABLE [Products] (
        [ProductId] bigint NOT NULL IDENTITY,
        [Name] nvarchar(max) NULL,
        [Category] nvarchar(max) NULL,
        [Description] nvarchar(max) NULL,
        [Price] decimal(8, 2) NOT NULL,
        [SupplierId] bigint NULL,
        CONSTRAINT [PK_Products] PRIMARY KEY ([ProductId]),
        CONSTRAINT [FK_Products_Suppliers_SupplierId] FOREIGN KEY ([SupplierId]) REFERENCES [Suppliers] ([SupplierId]) ON DELETE NO ACTION
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210816123718_Initial')
BEGIN
    CREATE TABLE [Ratings] (
        [RatingId] bigint NOT NULL IDENTITY,
        [Stars] int NOT NULL,
        [ProductId] bigint NULL,
        CONSTRAINT [PK_Ratings] PRIMARY KEY ([RatingId]),
        CONSTRAINT [FK_Ratings_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE NO ACTION
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210816123718_Initial')
BEGIN
    CREATE INDEX [IX_Products_SupplierId] ON [Products] ([SupplierId]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210816123718_Initial')
BEGIN
    CREATE INDEX [IX_Ratings_ProductId] ON [Ratings] ([ProductId]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210816123718_Initial')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210816123718_Initial', N'3.1.6');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210820153129_ChangeDeleteBehavior')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210820153129_ChangeDeleteBehavior', N'3.1.6');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210820171146_removedelete')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210820171146_removedelete', N'3.1.6');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210820172739_adddelete')
BEGIN
    ALTER TABLE [Products] DROP CONSTRAINT [FK_Products_Suppliers_SupplierId];
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210820172739_adddelete')
BEGIN
    ALTER TABLE [Ratings] DROP CONSTRAINT [FK_Ratings_Products_ProductId];
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210820172739_adddelete')
BEGIN
    ALTER TABLE [Products] ADD CONSTRAINT [FK_Products_Suppliers_SupplierId] FOREIGN KEY ([SupplierId]) REFERENCES [Suppliers] ([SupplierId]) ON DELETE SET NULL;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210820172739_adddelete')
BEGIN
    ALTER TABLE [Ratings] ADD CONSTRAINT [FK_Ratings_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210820172739_adddelete')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210820172739_adddelete', N'3.1.6');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210829104011_Orders')
BEGIN
    CREATE TABLE [Payment] (
        [PaymentId] bigint NOT NULL IDENTITY,
        [CardNumber] nvarchar(max) NOT NULL,
        [CardExpiry] nvarchar(max) NOT NULL,
        [CardSecurityCode] nvarchar(max) NOT NULL,
        [Total] decimal(8, 2) NOT NULL,
        [AuthCode] nvarchar(max) NULL,
        CONSTRAINT [PK_Payment] PRIMARY KEY ([PaymentId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210829104011_Orders')
BEGIN
    CREATE TABLE [Orders] (
        [OrderId] bigint NOT NULL IDENTITY,
        [Name] nvarchar(max) NOT NULL,
        [Address] nvarchar(max) NOT NULL,
        [PaymentId] bigint NOT NULL,
        [Shipped] bit NOT NULL,
        CONSTRAINT [PK_Orders] PRIMARY KEY ([OrderId]),
        CONSTRAINT [FK_Orders_Payment_PaymentId] FOREIGN KEY ([PaymentId]) REFERENCES [Payment] ([PaymentId]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210829104011_Orders')
BEGIN
    CREATE TABLE [CartLine] (
        [CartLineId] bigint NOT NULL IDENTITY,
        [ProductId] bigint NOT NULL,
        [Quantity] int NOT NULL,
        [OrderId] bigint NULL,
        CONSTRAINT [PK_CartLine] PRIMARY KEY ([CartLineId]),
        CONSTRAINT [FK_CartLine_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([OrderId]) ON DELETE NO ACTION
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210829104011_Orders')
BEGIN
    CREATE INDEX [IX_CartLine_OrderId] ON [CartLine] ([OrderId]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210829104011_Orders')
BEGIN
    CREATE INDEX [IX_Orders_PaymentId] ON [Orders] ([PaymentId]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20210829104011_Orders')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210829104011_Orders', N'3.1.6');
END;

GO

