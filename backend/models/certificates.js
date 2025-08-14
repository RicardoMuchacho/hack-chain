module.exports = (sequelize, DataTypes) => {
  const Certificate = sequelize.define("Certificate", {
    title: {
      type: DataTypes.STRING,
      allowNull: false
    },
    issueDate: {
      type: DataTypes.DATE,
      allowNull: false
    },
    studentId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "Students", // table name
        key: "id"
      },
      onDelete: "CASCADE"
    },
    issuerId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: "Issuers", // table name
        key: "id"
      },
      onDelete: "CASCADE"
    }
  });

  Certificate.associate = (models) => {
    // A certificate belongs to an student
    Certificate.belongsTo(models.Student, { foreignKey: 'studentId' });
    // A certificate is issued by an Issuer
    Certificate.belongsTo(models.Issuer, { foreignKey: 'issuerId' });
  };

  return Certificate;
};