defmodule TimeManager.Store do
  @moduledoc """
  The Store context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo
  alias TimeManager.Store.Schedule
  alias TimeManager.Store.User
  alias TimeManager.Store.Team
  alias TimeManager.Store.WorkingTime
  alias TimeManager.Store.Clock

# USERS
  def list_users do
    User
    |> preload(:schedules)
    |> preload(:workingtimes)
    |> preload(:clocks)
    |> preload(:teams)
    |> Repo.all()
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
  end

  def get_user_id!(id) do
    from(u in User, where: u.id == ^id)
    |> preload(:workingtimes)
    |> preload(:schedules)
    |> preload(:clocks)
    |> preload(:teams)
    |> Repo.all()
  end

  def get_users_by_username!(username) do
    from(u in User, where: u.username == ^username)
    |> Repo.all()
  end

  def get_user_by_email_and_password!(email, password) do
    from(u in User, where: u.email == ^email and u.password_hash==^password)
    |> Repo.one
  end

  def get_users_by_email!(email) do
    from(u in User, where: u.email == ^email)
    |> Repo.all()
  end

  def get_users_by_username_and_email!(username, email) do
    from(u in User, where: u.username == ^username and u.email == ^email)
    |> Repo.all()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(id, attrs) do
    get_user!(id)
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_all_users_by_ids(users_ids) do
    from(u in User, where: u.id in ^users_ids)
    |> Repo.all
  end


#  CLOCKS

  def list_clocks do
    Repo.all(Clock)
  end

  def get_clock!(id), do: Repo.get!(Clock, id)

  def create_clock(user_id, attrs \\ %{}) do
    user = get_user!(user_id)
    user
    |> Ecto.build_assoc(:clocks)
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end



#  WORKINGTIMES
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def create_working_time(user_id, attrs \\ %{}) do
    user = get_user!(user_id)
    user
    |> Ecto.build_assoc(:workingtimes)
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  def get_workingtimes_by_user_id_and_working_time_id(user_id, working_time_id) do
    from(w in WorkingTime, where: w.user_id == ^user_id and w.id == ^working_time_id)
    |> Repo.all()
  end

  def get_workingtimes_by_start_and_end(userID, start, endVal) do
    from(w in WorkingTime, where: w.user_id == ^userID and w.start >= ^start and w.end <= ^endVal)
    |> Repo.all()
  end

  def get_workingtimes_by_start(userID, start) do
    from(w in WorkingTime, where: w.user_id == ^userID and w.start >= ^start)
    |> Repo.all()
  end

  def get_workingtimes_by_end(userID, endVal) do
    from(w in WorkingTime, where: w.user_id == ^userID and w.end <= ^endVal)
    |> Repo.all()
  end

  def get_clocks_by_user_id(user_id) do
    from(c in Clock, where: c.user_id == ^user_id)
    |> Repo.all()
  end

  def get_workingtimes_by_user_id(user_id) do
    from(c in WorkingTime, where: c.user_id == ^user_id)
    |> Repo.all()
  end




# TEAMS

  def get_team!(id) do
    Team
    |> Repo.get!(id)
    |> Repo.preload(:users)
  end

  def get_team_id!(id) do
    Team
    |> Repo.get!(id)
  end

  def list_teams() do
    Repo.all(Team) |> preload(:users)
  end
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end
  def get_team_by_name(name) do
    from(u in Team, where: u.name == ^name)
    |> preload(:users)
    |> Repo.all()
  end
#  def update_team(%Team{} = team, attrs) do
#    team
#    |> Team.changeset(attrs)
#    |> Repo.update()
#  end

  def link_team_user(user_id, team_id) do
    get_team!(team_id)
    |> Repo.preload(:users)
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:users, [get_user!(user_id)])
    |> Repo.update()
  end

  def get_teams_link() do
    Team
    |> preload(:users)
    |> Repo.all()
  end

  def get_user_in_team(user_id) do
    from(t in Team, where: t.user_id == ^user_id)
    |> Repo.all()
  end

  def update_team(%TimeManager.Store.Team{} = team, attrs) do
    employee_ids = attrs["employees"]
    employees = get_all_users_by_ids(employee_ids)
    team
    |> Repo.preload(:users)
    |> Team.changeset_update_users(employees)
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end


  #SCHEDULE

  def get_schedules_by_user_id(user_id) do
    from(c in Schedule, where: c.user_id == ^user_id)
    |> Repo.all()
  end
  def list_schedules do
    Repo.all(Schedule)
  end

  def get_schedule!(id), do: Repo.get!(Schedule, id)

  def create_schedule(user_id, attrs \\ %{}) do
    user = get_user!(user_id)
    user
    |> Ecto.build_assoc(:schedules)
    |> Schedule.changeset(attrs)
    |> Repo.insert()
  end

  def update_schedule(%Schedule{} = schedule, attrs) do
    schedule
    |> Schedule.changeset(attrs)
    |> Repo.update()
  end

  def delete_schedule(%Schedule{} = schedule) do
    Repo.delete(schedule)
  end

end
