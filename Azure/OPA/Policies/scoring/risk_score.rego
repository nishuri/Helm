package terraform.scoring

import data.terraform.signals.destructive
import data.terraform.signals.security
import data.terraform.signals.sensitive
import data.terraform.signals.complexity
import data.terraform.signals.environment
import data.config

risk_score := score {
  base := 0

  delete_score := destructive.delete_count * config.weights.delete
  replace_score := destructive.replace_count * config.weights.replace
  security_score := count(security.security_flags) * config.weights.security
  sensitive_score := sensitive.count_sensitive * config.weights.sensitive

  size_score := 0 {
    complexity.total_changes <= 5
  }

  size_score := config.weights.large_change {
    complexity.total_changes > 5
  }

  raw_score := base +
               delete_score +
               replace_score +
               security_score +
               sensitive_score +
               size_score

  multiplier := env_multiplier(environment.env)

  score := raw_score * multiplier
}

env_multiplier(env) = 1 {
  env == "dev"
}

env_multiplier(env) = 1.5 {
  env == "test"
}

env_multiplier(env) = 2 {
  env == "uat"
}

env_multiplier(env) = 3 {
  env == "prod"
}
