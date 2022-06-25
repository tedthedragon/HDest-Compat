#namespace TFLV::Upgrade;
#debug on

class ::Registry : Object play {
  array<string> upgrades;

  static ::Registry GetRegistry() {
    let reg = TFLV::EventHandler(StaticEventHandler.Find("TFLV::EventHandler"));
    DEBUG("GetRegistry: %s", TFLV::Util.SafeCls(reg));
    if (!reg) return null;
    return reg.UPGRADE_REGISTRY;
  }

  static void Register(string upgrade) {
    DEBUG("Register: %s", upgrade);
    if (GetRegistry().upgrades.find(upgrade) != GetRegistry().upgrades.size()) {
      // Assume that this is because a mod has tried to double-register an upgrade,
      // and permit it as a no-op.
      //ThrowAbortException("Duplicate upgrades named %s", upgrade);
      return;
    }
    GetRegistry().upgrades.push(upgrade);
  }

  // Can't be static because we need to call it during eventmanager initialization,
  // and at that point the EventHandler isn't findable.
  void RegisterBuiltins() {
    DEBUG("RegisterBuiltins");
    static const string UpgradeNames[] = {
      "::Armour",
      "::ArmourLeech",
      "::Damage",
      "::ExplosiveShots",
      "::FastShots",
      "::HomingShots",
      "::IncendiaryShots",
      "::LifeLeech",
      "::PiercingShots",
      "::Putrefaction",
      "::PoisonShots",
      "::Pyre",
      "::Resistance"
    };
    for (uint i = 0; i < UpgradeNames.size(); ++i) {
      upgrades.push(UpgradeNames[i]);
    }
  }

  static ::BaseUpgrade GenerateUpgrade() {
    let cls = GetRegistry().upgrades[random(0, GetRegistry().upgrades.size()-1)];
    return ::BaseUpgrade(new(cls));
  }

  static ::BaseUpgrade GenerateUpgradeForPlayer(TFLV::PerPlayerStats stats) {
    ::BaseUpgrade upgrade = null;
    while (upgrade == null) {
      upgrade = ::Registry.GenerateUpgrade();
      if (upgrade.IsSuitableForPlayer(stats)) return upgrade;
      upgrade.Destroy();
      upgrade = null;
    }
    return null; // unreachable
  }

  static ::BaseUpgrade GenerateUpgradeForWeapon(TFLV::WeaponInfo info) {
    ::BaseUpgrade upgrade = null;
    while (upgrade == null) {
      upgrade = ::Registry.GenerateUpgrade();
      if (upgrade.IsSuitableForWeapon(info)) return upgrade;
      upgrade.Destroy();
      upgrade = null;
    }
    return null; // unreachable
  }
}