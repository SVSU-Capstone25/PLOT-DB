INSERT INTO Roles ([NAME])
VALUES ('OWNER');
GO
INSERT INTO [dbo].[Users] (
        [FIRST_NAME],
        [LAST_NAME],
        [EMAIL],
        [PASSWORD],
        [ROLE_TUID],
        [ACTIVE]
    )
VALUES (
        'John',
        'Doe',
        'johndoe@example.com',
        'AQAAAAIAAYagAAAAEFzZ3GUoBNOm84A0137uKAqJpnKLQoKJBR7jvaxdhpbs9/qllpb4te/18Ho1SWb8eg==',
        1,
        1
    );
GO