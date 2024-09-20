import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const marketPlaceModule = buildModule("marketPlaceModule", (m) => {

  const market = m.contract("marketPlace");

  return { market };
});

export default marketPlaceModule;
