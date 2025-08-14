const bcrypt = require("bcrypt");

module.exports = (sequelize, DataTypes) => {
  const Student = sequelize.define("Student", {
    name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    lastName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    age: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    email: {
      type: DataTypes.STRING,
      unique: true,
      allowNull: false
    },
    passwordHash: {
      type: DataTypes.STRING,
      allowNull: false
    },
    walletAddress: {
      type: DataTypes.STRING,
      allowNull: false
    },
    privateKey: {
      type: DataTypes.STRING,
      allowNull: false
    }
  });

  // Hash password before saving
  Student.beforeCreate(async (student) => {
    const salt = await bcrypt.genSalt(10);
    student.passwordHash = await bcrypt.hash(student.passwordHash, salt);
  });

  // Relate students with certificates
  Student.associate = (models) => {
    Student.hasMany(models.Certificate, { foreignKey: 'studentId' });
  }

  return Student;
};
