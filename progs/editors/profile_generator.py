import json
from types import SimpleNamespace

# { "A" : Profile, "B" : Profile, "C" : Profile }

def load_profile(file_path) -> dict:
  return json.load(open(file_path), object_hook=lambda d: SimpleNamespace(**d))

def combine_profiles(profile1 : SimpleNamespace, profile2 : SimpleNamespace) -> SimpleNamespace:
  combined_profile = SimpleNamespace()
  for key in set(vars(profile1).keys()).union(vars(profile2).keys()):
    value1 = getattr(profile1, key, None)
    value2 = getattr(profile2, key, None)
    if isinstance(value1, list) and isinstance(value2, list):
      combined_value = value1 + value2
    elif isinstance(value1, dict) and isinstance(value2, dict):
      combined_value = {**value1, **value2}
    else:
      combined_value = value2 if value2 is not None else value1
    setattr(combined_profile, key, combined_value)
  return combined_profile 

def generate_primitive_profile(base_profile : SimpleNamespace, additional_profile : SimpleNamespace) -> SimpleNamespace:
  combined_profile = combine_profiles(base_profile, additional_profile)
  return combined_profile
