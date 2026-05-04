package terraform.changecontrol

import data.terraform.scoring
import data.config

change_control := {
  "change_type": change_type,
  "risk_score": scoring.risk_score,
  "environment": data.terraform.signals.environment.env
}

# Classification thresholds
change_type = "Standard" {
  scoring.risk_score <= config.thresholds.standard
}

change_type = "Normal" {
  scoring.risk_score > config.thresholds.standard
  scoring.risk_score <= config.thresholds.normal
}

change_type = "Emergency" {
  scoring.risk_score > config.thresholds.normal
}
