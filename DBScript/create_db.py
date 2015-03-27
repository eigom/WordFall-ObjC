
FILENAMES = ['data.adj', 'data.adv', 'data.noun', 'data.verb']
SQL_FILENAME = 'words.sql'
DB_FILENAME = 'words.sqlite'

def read_lines():
    lines = []

    for filename in FILENAMES:
        f = open(filename)
        
        for line in f.readlines():
            lines.append( {'line':line, 'type':filename[filename.index('.'):]} )

        f.close()

    # filter out comments
    lines = [line for line in lines if not line['line'].startswith(' ')]

    print "Read %d entries" % (len(lines))

    return lines

def extract_word_data(line):
    words, definition = line.split('|')
    words = words.strip()
    definition = definition.strip()

    words = words.split(' ')
    words = [word for word in words if len(word) >= 3 and word.isalpha()]

    return {'words':words, 'definition':definition}

# filter out phrases (for example "ready_to_hand(p)"")
def filter_words(words):
    return [word for word in words if '_' not in word]

def is_alt_words(word1, word2):
    return (sorted(word1.lower()) == sorted(word2.lower()))

def make_data():
    data = {'words':[], 'definitions':[], 'word_definitions':[], 'alt_words':[]}

    all_words = {}
    alt_words = {}

    wordid = 0
    definitionid = 0

    for line in read_lines():
        word_type = line['type']
        word_data = extract_word_data(line['line'])

        words = filter_words(word_data['words'])
        definition = word_data['definition']

        if len(words) == 0:
            continue

        # add definition
        data['definitions'].append({'id':definitionid, 'definition':definition})

        # add words
        for word in words:
            #
            # if word already in data then only add additional definition for it
            #
            if word in all_words:
                word_id = all_words[word]
            else:
                word_id = wordid
                data['words'].append({'id':wordid, 'word':word})
                all_words[word] = wordid
                wordid = wordid + 1

                #
                # save alt words
                #
                sorted_word = ''.join(sorted(word.lower()))

                if sorted_word not in alt_words:
                    alt_words[sorted_word] = []

                alt_words[sorted_word].append(word_id)

            data['word_definitions'].append({'word_id':word_id, 'definition_id':definitionid, 'type':word_type})

        definitionid = definitionid + 1

    #
    # sort words by length
    #
    data['words'] = sorted(data['words'], key=lambda w: len(w['word']))

    #
    # alt words
    #
    print "Processing alternative words...", 

    for word in all_words.keys():
        wordid = all_words[word]
        sorted_word = ''.join(sorted(word.lower()))

        for alt_wordid in alt_words[sorted_word]:
            if wordid != alt_wordid:
                data['alt_words'].append({'word_id':wordid, 'altword_id':alt_wordid})

    print len(data['alt_words']), "words"

    return data

def make_sql(data):
    print "Creating SQL..."

    sql = []

    sql.append('CREATE TABLE word(id INTEGER PRIMARY KEY NOT NULL, word TEXT NOT NULL);\n')
    sql.append('CREATE TABLE definition(id INTEGER PRIMARY KEY NOT NULL, definition TEXT NOT NULL);\n')
    sql.append('CREATE TABLE word_definition(word_id INTEGER NOT NULL, definition_id INTEGER NOT NULL, type TEXT NOT NULL, FOREIGN KEY (word_id) REFERENCES word(id), FOREIGN KEY (definition_id) REFERENCES definition(id));\n')
    sql.append('CREATE TABLE alt_word(word_id INTEGER NOT NULL, altword_id INTEGER NOT NULL, FOREIGN KEY (word_id) REFERENCES word(id), FOREIGN KEY (altword_id) REFERENCES word(id));\n')
    sql.append('CREATE TABLE word_length_max_id(length INTEGER NOT NULL, word_id INTEGER NOT NULL);\n')
    sql.append('CREATE TABLE word_count(count INTEGER NOT NULL);\n')

    word_length = 1
    
    for word in data['words']:
        if len(word['word']) > word_length:
            sql.append( "INSERT INTO word_length_max_id(length, word_id) VALUES(%d, %d);\n" % (word_length, word['id']) )
            word_length = len(word['word'])

        sql.append( "INSERT INTO word(id, word) VALUES(%d, '%s');\n" % (word['id'], word['word']) )

    for definition in data['definitions']:
        sql.append( "INSERT INTO definition(id, definition) VALUES(%d, '%s');\n" % (definition['id'], definition['definition'].replace("'", "''")) )

    for word_definition in data['word_definitions']:
        sql.append( "INSERT INTO word_definition(word_id, definition_id, type) VALUES(%d, %d, '%s');\n" % (word_definition['word_id'], word_definition['definition_id'], word_definition['type']) )

    for alt_word in data['alt_words']:
        sql.append( "INSERT INTO alt_word(word_id, altword_id) VALUES(%d, %d);\n" % (alt_word['word_id'], alt_word['altword_id']) )

    sql.append('INSERT INTO word_count(count) SELECT count(*) FROM word;\n')

    return sql

def create_db():
    import subprocess, os, os.path, sys
    
    # remove current db
    subprocess.call(['rm', DB_FILENAME])

    sql = make_sql(make_data())

    print "Writing to file..."

    #
    # write to file
    #
    f = open(SQL_FILENAME, 'w')
    f.writelines(sql)
    f.close()

    print "Populating db..."

    #
    # populate db
    #
    subprocess.call("sqlite3 %s < %s" % (DB_FILENAME, SQL_FILENAME), shell=True)

create_db()
