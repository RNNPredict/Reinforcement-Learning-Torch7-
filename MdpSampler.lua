local envutil = require 'envutil'
require 'EpisodeBuilder'

local MdpSampler = torch.class('MdpSampler')

function MdpSampler:__init(env, discount_factor)
    self.env = env
    self.discount_factor = discount_factor
end

function MdpSampler:sample_total_reward(policy)
    local s = self.env:get_start_state()
    local total_r, r = 0, 0
    while not self.env:is_terminal(s) do
        s, r = self.env:step(s, policy:get_action(s))
        total_r = total_r + r
    end
    return total_r
end

-- Episode: list of {state, action, discounted return, reward}. Indexed by time,
-- starting at time = 1.
function MdpSampler:get_episode(policy)
    local s = self.env:get_start_state()
    local r = 0
    local a = nil
    local next_s = nil
    local episode_builder = EpisodeBuilder(self.discount_factor)

    while not self.env:is_terminal(s) do
        a = policy:get_action(s)
        next_s, r = self.env:step(s, a)
        episode_builder:add_state_action_reward_step(s, a, r)
        s = next_s
    end

    return episode_builder:get_episode()
end
