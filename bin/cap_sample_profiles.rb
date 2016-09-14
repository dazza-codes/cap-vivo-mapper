
# Profiles used to test CAP to VIVO conversions:

# 25845 - Michael Halaas (SoM Staff)
STAFF = [25845]

#  4164 - Mark Musen (has postdoctoralAdvisees)
#  4706 - Russ Altman  (has postdoctoralAdvisees)
#  6367 - Craig Levin (has GraduateAndFellowshipPrograms and postdoctoralAdvisees)
#       - has postdocs: 51528, 49024, 37136
# 49224 - Michel Dumontier (has GraduateAndFellowshipPrograms and postdoctoralAdvisees)
#       - has postdocs: 68722
FACULTY = [4164, 4706, 6367, 48613, 49224]

# 48613 - both faculty and physician
# 5949 - Steven R. Alexander (is a SHC Faculty Physician)
PHYSICIANS = [5949,48613]

# Students with advisors:
# most postdocs have:
# profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Faculty Sponsor"
# 47441,62351,37521,53591,38061 # (same advisor)
# # (different advisors) have both:
# profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Faculty Sponsor"
# profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Research Mentor"
# 21125
# profile["stanfordAdvisors"][x]["position"] : "Postdoctoral Research Mentor"
# 46806,61829,44963,60202
# profile["stanfordAdvisors"][x]["position"] : "Doctoral (Program)"
# 40059
# profile["stanfordAdvisors"][x]["position"] : "Doctoral Dissertation Advisor (AC)"
# 34085 - Biafra Ahanonu (PhD Student)
# 68722 - Amrapali Zaveri (SoM Postdoc) of Michel Dumontier (49224)
STUDENTS = [
  51528, 49024, 37136,
  34085,68722,
  47441,62351,37521,53591,38061,
  21125,
  46806,61829,44963,60202,
  40059]

def test_profiles
  test_ids = STAFF.concat FACULTY.concat PHYSICIANS.concat STUDENTS
  #test_ids.uniq.shuffle!
end

