const HealthcareSystem = artifacts.require("HealthcareSystem");

module.exports = function (deployer) {
  deployer.deploy(HealthcareSystem);
};
