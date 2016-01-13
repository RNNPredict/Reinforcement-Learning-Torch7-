local eval = require 'evaluation'
local mc = require 'montecarlo'
local ql = require 'qlearning'

math.randomseed(os.time())

local cmd = torch.CmdLine()
cmd:option('-min', 1,'minimum log_10(# iterations)')
cmd:option('-max', 5,'minimum log_10(# iterations)')

local params = cmd:parse(arg)

local mc_eval = mc.montecarlo_eval_policy
for n = params.min, params.max do
    local num_iters = 10^n
    eval.displayMetrics(
        ql.get_policy(num_iters, mc_eval),
        'MC, # iters = ' .. num_iters)
end

