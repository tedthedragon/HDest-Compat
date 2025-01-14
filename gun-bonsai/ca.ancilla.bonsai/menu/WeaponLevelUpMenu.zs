#namespace TFLV::Menu;

class ::WeaponLevelUpMenu : ::GenericMenu {
  override void Init(Menu parent, OptionMenuDescriptor desc) {
    super.Init(parent, desc);
    mDesc.mItems.Clear();

    let stats = TFLV::EventHandler.GetConsolePlayerStats();
    let giver = TFLV::WeaponUpgradeGiver(stats.currentEffectGiver);

    PushText("", Font.CR_GOLD);
    PushText(
      string.format(
        StringTable.Localize("$TFLV_MENU_WEAPON_LEVELUP"),
        giver.wielded.wpn.GetTag()),
      Font.CR_GOLD);

    mDesc.mSelectedItem = -1;
    for (uint i = 0; i < giver.candidates.size(); ++i) {
      PushUpgrade(giver.candidates[i], i);
    }

    PushText("", Font.CR_LIGHTBLUE);
    PushText("$TFLV_MENU_CURRENT_UPGRADES", Font.CR_LIGHTBLUE);
    giver.wielded.upgrades.DumpToMenu(self);
    return;
  }

  void PushUpgrade(TFLV::Upgrade::BaseUpgrade upgrade, int index) {
    PushKeyValueOption(
      upgrade.GetName(), upgrade.GetDesc(),
      "bonsai-choose-level-up-option",
      index);
  }

  override bool MenuEvent(int key, bool fromController) {
    if (key == Menu.MKey_Back) {
      EventHandler.SendNetworkEvent("bonsai-choose-level-up-option", -1);
    }

    return super.MenuEvent(key, fromController);
  }
}
