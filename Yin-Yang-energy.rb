=begin ~~~o                                                          o~~~ begin=
                    :...~o[ Doctor Bug's ������������ ]o~...:

                        :...~o[ Yin_&_Yang energy ]o~...:
                          
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                            �����:  Doctor Bug
                            ���:    RPGMAKER VX ACE 
                            ������: 0.3
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                        :...~o[ ������� ������ ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~

    2019-05-26 -> ������ 0.4
               - �� ������ ���
    2018-09-19 -> ������ 0.3
               - ��������� ��� 4 �������. �������� � ��������� ���������.
    2018-09-17 -> ������ 0.2
               - ������� � �������. 
                "Yanfly Engine Ace - Ace Battle Engine v1.22"
                ����� �������� � ��� ����.
    2018-09-17 -> ������ 0.1
               - ����������
               
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                           :...~o[ �������� ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    ���� ������ ��������� �������������� ��������� � �����, ������� ������.
    ���� ����������� ��� �������. �������� ����������� ��������� � ���� 
    ���������, ����� ����.
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                          :...~o[ ���������� ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    ������ ���������� � �������� ������ ��� Main. 
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                          :...~o[ ����� ������� ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    ��������� ��������������� ������� � ������� ������ (������), ������ �� 
    ��� ��������� ��������������� ��������:
    <delete_state: id>	  # ~~o ������� � ������������� ���������� ���������. 
                                        ����� ������� ����� (id) ���������.
    <delete_states>		    # ~~o ������� � ������������� ��� ���������. 
    <transfer_state: id>  # ~~o �������� ��������� ����-����. ����� ������������
                                � ����. ����� ������� ����� (id) ���������.
    <transfer_states>     # ~~o �������� ��� ��������� ���� ����.
    <take_state: id>      # ~~o �������� ���� ���������� ��������� ����-����.
                                        ����� ������� ����� (id) ���������.
    <take_states>         # ~~o �������� ���� ��� ��������� ����-����.                                  
    
    �������� ������ � ������� �������� ��������. ���� ���.
        
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                          :...~o[ ���������� ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    ������ ������ ����� ������������ � ����� ��������.
    � ��� ����� � ������������. 
    ���� ������� �� ��������� (Doctor Bug Lindesh) �� ������ ������.     
=end

class RPG::BaseItem

  def delete_state
    if @delete_state.nil?
      if @note =~ /<delete_state:[ ](.*)>/i
        @delete_state = $1.to_i
      else
        @delete_state = 0
      end
    end
    @delete_state
  end
  
  def delete_states
    if @note =~ /<delete_states>/i
      return true
    else
      return false
    end
  end
  
  def transfer_state
    if @transfer_state.nil?
      if @note =~ /<transfer_state:[ ](.*)>/i
        @transfer_state = $1.to_i
      else
        @transfer_state = 0
      end
    end
    @transfer_state
  end
  
  def transfer_states
    if @note =~ /<transfer_states>/i
      return true
    else
      return false
    end
  end
  
  def take_state
    if @take_state.nil?
      if @note =~ /<take_state:[ ](.*)>/i
        @take_state = $1.to_i
      else
        @take_state = 0
      end
    end
    @take_state
  end
  
  def take_states
    if @note =~ /<take_states>/i
      return true
    else
      return false
    end
  end
    
end # RPG::Item

class Game_BattlerBase
  def buffs
    @buffs
  end
end

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Execute Battle Actions
  #--------------------------------------------------------------------------
  def execute_action
    @subject.sprite_effect_type = :whiten
    use_item
    @log_window.wait_and_clear
  end
  
  unless $imported.nil?
    if $imported["YEA-BattleEngine"]
    #~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    #                :...~o[ overwrite method: use_item ]o~...:                      
    #~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
      def use_item
        item = @subject.current_action.item
        @log_window.display_use_item(@subject, item)
        @subject.use_item(item)
        status_redraw_target(@subject)
        if $imported["YEA-LunaticObjects"]
          lunatic_object_effect(:before, item, @subject, @subject)
        end
        process_casting_animation if $imported["YEA-CastAnimations"]
        targets = @subject.current_action.make_targets.compact rescue []
        manipulation_of_energy_Jin(item,targets)
        show_animation(targets, item.animation_id) if show_all_animation?(item)
        targets.each {|target| 
          if $imported["YEA-TargetManager"]
            target = alive_random_target(target, item) if item.for_random?
          end
          item.repeats.times { invoke_item(target, item) } }
        if $imported["YEA-LunaticObjects"]
          lunatic_object_effect(:after, item, @subject, @subject)
        end
      end
    end
  else
    #~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    #                :...~o[ overwrite method: use_item ]o~...:                      
    #~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    def use_item
      item = @subject.current_action.item
      @log_window.display_use_item(@subject, item)
      @subject.use_item(item)
      refresh_status
      targets = @subject.current_action.make_targets.compact
      manipulation_of_energy_Jin(item,targets)
      show_animation(targets, item.animation_id)
      targets.each {|target| item.repeats.times { invoke_item(target, item) } }
    end  
  end
  
  def manipulation_of_energy_Jin(item,targets)
    check_states(item,targets)
    take_states(item,targets)
  end
  
  def check_states(item,targets)
    @subject.states.each do |state|
      #puts "state #{state.id}"
      bring_states(item,state)
      targets.each do |target|
        transfer_states(item,target,state)
      end
    end
  end
  
  #~~o~~o �������� ��������� ��� �������� ���� ���������
  def transfer_states(item,target,state)
    @subject.states.each do |state|
      if @subject.state?(item.transfer_state)
        target.add_state(item.transfer_state)
      end
      if item.transfer_states
        target.add_state(state.id)
      end
    end
  end
  
  #~~o~~o �������� ��������� � ����
  def take_states(item,targets)
    targets.each do |target|
      if target.state?(item.take_state)
        target.erase_state(item.take_state)
        @subject.add_state(item.take_state)
      end
      if item.take_states
        target.states.each do |state|
          target.erase_state(state.id)
          @subject.add_state(state.id)
        end
      end
    end
  end
  
  def bring_states(item,state)
    @subject.erase_state(state.id) if item.delete_states
    @subject.erase_state(state.id) if @subject.state?(item.delete_state)
  end
end