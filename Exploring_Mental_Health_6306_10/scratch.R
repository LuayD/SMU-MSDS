head (lst_data_attributes)

lst_data_attributes[(length(lst_data_attributes)-10):length(lst_data_attributes)]

length(lst_data_attributes)-10:length(lst_data_attributes)
129:129
(x-10):x
130:120
attributes(mh2015_puf[])

vec1 = c(1,2,3)
vec2 = c(4,5,6)
df_names = c("one","two","three")
df_colnames = c("Vector1", "Vector2")
df_attr = c("this is one", "this is two")
names(df_attr) = df_colnames

df = data.frame(vec1, vec2)
rownames(df) = df_names
colnames(df) = df_colnames
attr(df, "variable labels") =  df_attr
attr(df, "codepage") = as.integer(65001)
colnames(mh2015_puf)

grep(":alpha::alpha:", "AK    ")

gsub("\\n | ^ *|(?<= ) | *$", "", "AK    ", perl = TRUE)
gsub(" ", "", "AK    ")

# find through interation which states not included in country
vec_mainland_states_abbrev <- vec_state_abbrev[!is.element(vec_state_abbrev, vec_territory_abbrev)]

