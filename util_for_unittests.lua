local M = {}

function M.are_testmdp_policy_probabilities_good(policy, expected_probabilities)
    local n_times_action = {0, 0, 0}
    local n_iters = 10000
    for i = 1, n_iters do
        local state = math.random(1, 2)
        local a = policy:get_action(state)
        n_times_action[a] = n_times_action[a] + 1
    end

    for action = 1, 3 do
        if not util.is_prob_good(
                n_times_action[action],
                expected_probabilities[action],
                n_iters) then
            return false
        end
    end
    return true
end

function M.are_tensors_same_shape(t1, t2)
    if t1:dim() ~= t2:dim() then
        return false
    end
    for d = 1, t1:dim() do
        if (#t1)[d] ~= (#t2)[d] then
            return false
        end
    end
    return true
end

return M