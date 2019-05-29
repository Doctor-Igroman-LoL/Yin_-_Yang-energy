=begin ~~~o                                                          o~~~ begin=
                    :...~o[ Doctor Bug's представляет ]o~...:

                        :...~o[ Yin_&_Yang energy ]o~...:
                          
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                            Автор:  Doctor Bug
                            Для:    RPGMAKER VX ACE 
                            Версия: 0.5
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                        :...~o[ История версий ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    2019-05-30 -> Версия 0.6
               - Добавлена комбо-скилл-состояний. Активирует указаный скилл, 
                при условии, если на цели будут наложены соответствующие
                состояния. <activate: id if states_combo: stata_id stata_id>
    2019-05-28 -> Версия 0.5
               - Добавлены две команды: <give_away: id> и <give_away_all>
    2019-05-26 -> Версия 0.4
               - По фиксен Баг
    2018-09-19 -> Версия 0.3
               - Добавлены еще 4 команды. Передача и забирания состояний.
    2018-09-17 -> Версия 0.2
               - Скрещен с Янфлаем. 
                "Yanfly Engine Ace - Ace Battle Engine v1.22"
                Может работать и без него.
    2018-09-17 -> Версия 0.1
               - Реализация
               
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                           :...~o[ Описание ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    Этот скрипт позволяет перенаправлять состояния и баффы, дебаффы героев.
    Пока реализованы две команды. Удаления конкретного состояние и всех 
    состояний, через скил.
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                          :...~o[ Инструкция ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    Просто скопируйте и вставьте скрипт над Main. 
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                          :...~o[ Вызов скрипта ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    Поместите соответствующие команды в заметки скилла (навыка), каждая из 
    них выполняет соответствующие действие:
    <delete_state: id>	  # ~~o удаляет с использующего конкретное состояние. 
                                        Нужно указать номер (id) состояния.
    <delete_states>		    # ~~o удаляет с использующего все состояние. 
    <transfer_state: id>  # ~~o передает состояние кому-либо. Можно использовать
                                в паре. Нужно указать номер (id) состояния.
    <transfer_states>     # ~~o передает все состояние кому либо.
    <take_state: id>      # ~~o забирает себе конкретное состояние с цели.
                                        Нужно указать номер (id) состояния.
    <take_states>         # ~~o забирает себе все состояние кого-либо.
    <give_away: id>       # ~~o отдает конкретное состояние цели.
                                        Нужно указать номер (id) состояния.
    <give_away_all>       # ~~o отдает все состояние кого-либо.
    
    <activate: id if states_combo: stata_id stata_id>
    #~~o Добавлена комбо-скилл-состояний. Активирует указаный скилл, 
    при условии, если на цели будут наложены соответствующие состояния.
    id - навык который нужно активировать
    stata_id - id состояний которые должны быть у цели, для выполнения условии. 
        
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
                          :...~o[ Требование ]o~...:
#~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~o~~~
    Данный скрипт можно использовать в любых проектах.
    В том числе и коммерческих. 
    Если указано моё авторство (Doctor Bug Lindesh) на данный скрипт.     
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
  
  def give_away
    if @give_away.nil?
      if @note =~ /<give_away:[ ](.*)>/i
        @give_away = $1.to_i
      else
        @give_away = 0
      end
    end
    @give_away    
  end
  
  def give_away_all
    if @note =~ /<give_away_all>/i
      return true
    else
      return false
    end
  end
  
  def states_cobmo
    if @states_cobmo.nil?
      if @note =~ /<activate: (.*) if states_combo: (.*)>/i
        @arr_states = $2.to_s.split(" ").map {|i| i.to_i}
        @states_cobmo = [$1.to_i, @arr_states.sort]
      else
        @states_cobmo = []
      end
    end
    @states_cobmo
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
        #targets.each {|target|
        #  puts "target #{target.name}"
        #}
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
  
  #--------------------------------------------------------------------------
  # alias method: invoke_item
  #--------------------------------------------------------------------------
  alias scene_battle_invoke_item_drbug invoke_item
  def invoke_item(target, item)
    if target.dead? != item.for_dead_friend?
      @subject.last_target_index = target.index
      return
    end
    combo_states(target, item)
    scene_battle_invoke_item_drbug(target, item)
  end
  
  def manipulation_of_energy_Jin(item,targets)
    check_states(item,targets)
    take_states(item,targets)
    #combo_states(item, targets)
  end
  
  def check_states(item,targets)
    @subject.states.each do |state|
      #puts "state #{state.id}"
      bring_states(item,state)
      targets.each do |target|
        give_away(item,target,state)
        transfer_states(item,target,state)
      end
    end
  end
  
  # Удалить состояние
  def bring_states(item,state)
    @subject.erase_state(state.id) if item.delete_states
    @subject.erase_state(state.id) if @subject.state?(item.delete_state)
  end
  
  #~~o~~o Делиться состояния или передача всех сосотяний. 
  #~~o~~o Исходное состояние остается
  def transfer_states(item,target,state)
    if @subject.state?(item.transfer_state)
      target.add_state(item.transfer_state)
    end
    if item.transfer_states
      target.add_state(state.id)
    end
  end
  
  #~~o~~o Отдаёт состояния или отдаёт все сосотяние. 
  def give_away(item,target,state)
    if @subject.state?(item.give_away)
      @subject.erase_state(item.give_away)
      target.add_state(item.give_away)
    end
    if item.give_away_all
      @subject.erase_state(state.id)
      target.add_state(state.id)
    end
  end
  
  #~~o~~o Забирает состояния у цели
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
  
  #~~o~~o Проверка на комбинацию состояний противника
  def combo_states(target, item)
    @list_state = []
    # Собираем массив из id состояний цели в массив @list_state
    target.states.map{ |state| @list_state.push(state.id)}
    # Узнаем "комбинацию состояний" с навыка, если есть
    combo = item.states_cobmo[1]
    # Пересечений массивов
    @temp_combo_skill = combo & @list_state
    if @temp_combo_skill == combo
      @temp_combo_skill.each {|state|
        target.erase_state(state)
      }
      attack_skill = $data_skills[item.states_cobmo[0]]
      target.item_apply(target, attack_skill) 
      refresh_status
      @log_window.display_action_results(target, attack_skill)
    end    
  end
  
end
