------------------
  Game_Interpreter
------------------

  #--------------------------------------------------------------------------
  # * Force Action
  #--------------------------------------------------------------------------
  def command_339
    iterate_battler(@params[0], @params[1]) do |battler|
      next if battler.death_state?
      battler.force_action(@params[2], @params[3])
      BattleManager.force_action(battler)
      Fiber.yield while BattleManager.action_forced?
    end
  end

  #--------------------------------------------------------------------------
  # * Battler Iterator (Account for Entire Enemy Group or Entire Party)
  #     param1 : If 0, enemy. If 1, actor.
  #     param2:  Index if enemy and ID if actor.
  #--------------------------------------------------------------------------
  def iterate_battler(param1, param2)
    if $game_party.in_battle
      if param1 == 0
        iterate_enemy_index(param2) {|enemy| yield enemy }
      else
        iterate_actor_id(param2) {|actor| yield actor }
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    @fiber.resume if @fiber
  end

---------------
  BattleManager
---------------
  #--------------------------------------------------------------------------
  # * Force Action
  #--------------------------------------------------------------------------
  def self.force_action(battler)
    @action_forced = battler
    @action_battlers.delete(battler)
  end

  #--------------------------------------------------------------------------
  # * Get Forced State of Battle Action
  #--------------------------------------------------------------------------
  def self.action_forced?
    @action_forced != nil
  end

---------------
  Game_Battler
---------------
  #--------------------------------------------------------------------------
  # * Force Action
  #--------------------------------------------------------------------------
  def force_action(skill_id, target_index)
    clear_actions
    action = Game_Action.new(self, true)					-------------
    action.set_skill(skill_id)								 Game_Action: 
    if target_index == -2									#-------------------------------------------------------
      action.target_index = last_target_index				  # * Set Skill
    elsif target_index == -1							    #-------------------------------------------------------
      action.decide_random_target 							 def set_skill(skill_id)
    else													    @item.object = $data_skills[skill_id]
      action.target_index = target_index 					    self
    end 												     end
    @actions.push(action)
  end

--------------
  Scene_Battle
--------------
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if BattleManager.in_turn?
      process_event
      process_action
    end
    BattleManager.judge_win_loss
  end

  #--------------------------------------------------------------------------
  # * Event Processing
  #--------------------------------------------------------------------------
  def process_event
    while !scene_changing?
      $game_troop.interpreter.update
      $game_troop.setup_battle_event
      wait_for_message
      wait_for_effect if $game_troop.all_dead?
      process_forced_action
      BattleManager.judge_win_loss
      break unless $game_troop.interpreter.running?
      update_for_wait
    end
  end

  #--------------------------------------------------------------------------
  # * Battle Action Processing
  #--------------------------------------------------------------------------
  def process_action
    return if scene_changing?
    if !@subject || !@subject.current_action
      @subject = BattleManager.next_subject
    end
    return turn_end unless @subject
    if @subject.current_action
      @subject.current_action.prepare
      if @subject.current_action.valid?
        @status_window.open
        execute_action
      end
      @subject.remove_current_action
    end
    process_action_end unless @subject.current_action
  end  

  #--------------------------------------------------------------------------
  # * Execute Battle Actions
  #--------------------------------------------------------------------------
  def execute_action
    @subject.sprite_effect_type = :whiten
    use_item
    @log_window.wait_and_clear
  end

  #--------------------------------------------------------------------------
  # * Use Skill/Item
  #--------------------------------------------------------------------------
  def use_item
    item = @subject.current_action.item
    @log_window.display_use_item(@subject, item)
    @subject.use_item(item)
    refresh_status
    targets = @subject.current_action.make_targets.compact
->  manipulation_of_energy_Jin(item,targets)
    show_animation(targets, item.animation_id)
    targets.each {|target| item.repeats.times { invoke_item(target, item) } }	# invoke_item - вызывать предмет
  end

  #--------------------------------------------------------------------------
  # * Forced Action Processing
  #--------------------------------------------------------------------------
  def process_forced_action
    if BattleManager.action_forced?
      last_subject = @subject
      @subject = BattleManager.action_forced_battler
      BattleManager.clear_action_force
      process_action
      @subject = last_subject
    end
  end

  #--------------------------------------------------------------------------
  # * End Turn
  #--------------------------------------------------------------------------
  def turn_end
    all_battle_members.each do |battler|
      battler.on_turn_end
      refresh_status
      @log_window.display_auto_affected_status(battler)
      @log_window.wait_and_clear
    end
    BattleManager.turn_end
    process_event
    start_party_command_selection
  end

  #--------------------------------------------------------------------------
  # * Invoke Skill/Item
  #--------------------------------------------------------------------------
  def invoke_item(target, item)
    if rand < target.item_cnt(@subject, item)
      invoke_counter_attack(target, item)
    elsif rand < target.item_mrf(@subject, item)
      invoke_magic_reflection(target, item)
    else
      apply_item_effects(apply_substitute(target, item), item)
    end
    @subject.last_target_index = target.index
  end

++++++++++++++++++++++++++++++ Game_Battler +++++++++++++++++++++++++++++++++
  #--------------------------------------------------------------------------
  # * Calculate Counterattack Rate for Skill/Item
  #--------------------------------------------------------------------------
  def item_cnt(user, item)
    return 0 unless item.physical?          # Hit type is not physical
    return 0 unless opposite?(user)         # No counterattack on allies
    return cnt                              # Return counterattack rate
  end

  #--------------------------------------------------------------------------
  # * Calculate Reflection Rate of Skill/Item
  #--------------------------------------------------------------------------
  def item_mrf(user, item)
    return mrf if item.magical?     # Return magic reflection if magic attack
    return 0
  end

  #--------------------------------------------------------------------------
  # * Determine if Hostile Relation
  #--------------------------------------------------------------------------
  def opposite?(battler)
    actor? != battler.actor? || battler.magic_reflection
  end

  #--------------------------------------------------------------------------
  # * Determine if Actor or Not
  #--------------------------------------------------------------------------
  def actor?
    return false
  end
  ++++++++++++++++++++++++++++++ Game_Actor +++++++++++++++++++++++++++++++++++
  #--------------------------------------------------------------------------
  # * Determine if Actor or Not
  #--------------------------------------------------------------------------
  def actor?
    return true
  end
  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  #--------------------------------------------------------------------------
  # * Invoke Counterattack
  #--------------------------------------------------------------------------
  def invoke_counter_attack(target, item)
    @log_window.display_counter(target, item)
    attack_skill = $data_skills[target.attack_skill_id]
    @subject.item_apply(target, attack_skill)
    refresh_status
    @log_window.display_action_results(@subject, attack_skill)
  end

  #--------------------------------------------------------------------------
  # * Invoke Magic Reflection
  #--------------------------------------------------------------------------
  def invoke_magic_reflection(target, item)
    @subject.magic_reflection = true
    @log_window.display_reflection(target, item)
    apply_item_effects(@subject, item)
    @subject.magic_reflection = false
  end

  #--------------------------------------------------------------------------
  # * Apply Skill/Item Effect
  #--------------------------------------------------------------------------
  def apply_item_effects(target, item)
    target.item_apply(@subject, item)
    refresh_status
    @log_window.display_action_results(target, item)
  end

  #--------------------------------------------------------------------------
  # * Apply Substitute
  #--------------------------------------------------------------------------
  def apply_substitute(target, item)
    if check_substitute(target, item)
      substitute = target.friends_unit.substitute_battler
      if substitute && target != substitute
        @log_window.display_substitute(substitute, target)
        return substitute
      end
    end
    target
  end

---------------
  Game_Battler
---------------
  #--------------------------------------------------------------------------
  # * Apply Effect of Skill/Item
  #--------------------------------------------------------------------------
  def item_apply(user, item)
    @result.clear
    @result.used = item_test(user, item)
    @result.missed = (@result.used && rand >= item_hit(user, item))
    @result.evaded = (!@result.missed && rand < item_eva(user, item))
    if @result.hit?
      unless item.damage.none?
        @result.critical = (rand < item_cri(user, item))
        make_damage_value(user, item)
        execute_damage(user)
      end
      item.effects.each {|effect| item_effect_apply(user, item, effect) }
      item_user_effect(user, item)
    end
  end

  #--------------------------------------------------------------------------
  # * Test Skill/Item Application
  #    Used to determine, for example, if a character is already fully healed
  #   and so cannot recover anymore.
  #--------------------------------------------------------------------------
  def item_test(user, item)
    return false if item.for_dead_friend? != dead?
    return true if $game_party.in_battle
    return true if item.for_opponent?
    return true if item.damage.recover? && item.damage.to_hp? && hp < mhp
    return true if item.damage.recover? && item.damage.to_mp? && mp < mmp
    return true if item_has_any_valid_effects?(user, item)
    return false
  end

---------------
  Game_Troop
---------------
  #--------------------------------------------------------------------------
  # * Battle Event Setup
  #--------------------------------------------------------------------------
  def setup_battle_event
    return if @interpreter.running?
    return if @interpreter.setup_reserved_common_event
    troop.pages.each do |page|
      next unless conditions_met?(page)
      @interpreter.setup(page.list)
      @event_flags[page] = true if page.span <= 1
      return
    end
  end
