#!/usr/bin/env python
#==============================================================================
# Copyright 2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use
# this file except in compliance with the License. A copy of the License is
# located at
#
#       http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
# implied. See the License for the specific language governing permissions
# and limitations under the License.
#==============================================================================

from lib.utility import misc

class TemplateSnippet(object):
    
    def __init__(self, snippet_name = None, source_url = None, order = None):
        self._snippet_name = snippet_name
        self._source_url = source_url
        self._order = order

    @property
    def snippet_name(self):
        return self._snippet_name

    @property
    def source_url(self):
        return self._source_url

    @property
    def order(self):
        return self._order
    
    @snippet_name.setter    
    def snippet_name(self, snippet_name):
        self._snippet_name = snippet_name
    
    @source_url.setter    
    def source_url(self, source_url):
        self._source_url = source_url
    
    @order.setter    
    def order(self, order):
        self._order = order

    
class Version(object):

    def __init__(self, application_name = None, version_label = None):
        self._application_name = application_name
        self._version_label = version_label
    
    @property
    def application_name(self):
        return self._application_name

    @property
    def version_label(self):
        return self._version_label
    
    @application_name.setter    
    def application_name(self, application_name):
        self._application_name = application_name
    
    @version_label.setter    
    def version_label(self, version_label):
        self._version_label = version_label


class TemplateSpecification(object):

    def __init__(self, template_source = None, template_snippets = None):
        if template_source is None:
            self._template_source = TemplateSource()
        else:
            self._template_source = template_source
        if template_snippets is None:
            self._template_snippets = list()
        else:
            self._template_snippets = template_snippets
                
    @property
    def template_source(self):
        return self._template_source

    @property
    def template_snippets(self):
        return self._template_snippets
    
    @template_source.setter    
    def template_source(self, template_source):
        self._template_source = template_source

    @template_snippets.setter    
    def template_snippets(self, snippets):
        self._template_snippets = snippets
  


class TemplateSource(object):

    def __init__(self, solution_stack_name = None):
        self._solution_stack_name = solution_stack_name
    
    @property
    def solution_stack_name(self):
        return self._solution_stack_name
    
    @solution_stack_name.setter    
    def solution_stack_name(self, solution_stack_name):
        self._solution_stack_name = solution_stack_name
   

class Request(object):
    '''
    Convert and store EB request parameters
    '''
    
    def __init__(self):
        self._request = dict()

    def _set_to_list(self, name_set):
        name_list = []
        if isinstance(name_set, set):
            for name in name_set:
                name_list.append(str(name))
        else:
            name_list.append(str(name_set))
        return name_list         

    def _check_boolean(self, switch):
        if isinstance(switch, bool):
            if switch:
                return 'true'
            else:
                return 'false'
        else:
            return switch
    
    def __repr__(self):
        try:
            text = 'Request API: {0}. \nParameters: [\n'.format(self._request['Operation'])
        except:
            text = 'Parameters:[\n'
        
        for key,value in self._request.items():
            text = text + ' {0} : {1}\n'.format(key, value)
        text = text + ']'
        
        return text
    
    def get_dict(self):
        return self._request
    
    def set_operation(self, name):
        self._request['Operation'] = misc.to_unicode(name)

    def set_app_name(self, name):
        self._request['ApplicationName'] = misc.to_unicode(name)

    def set_app_names(self, name_set):
        name_list = self._set_to_list(name_set)
        for i in range(len(name_list)):
            self._request['ApplicationNames.member.' + misc.to_unicode(i + 1)] \
                = misc.to_unicode(name_list[i])
                
    def set_version_label(self, name):
        self._request['VersionLabel'] = misc.to_unicode(name)
        
    def set_description(self, description):
        self._request['Description'] = misc.to_unicode(description)

    def set_s3bucket(self, bucket):
        self._request['SourceBundle.S3Bucket'] = misc.to_unicode(bucket)

    def set_s3key(self, key):
        self._request['SourceBundle.S3Key'] = misc.to_unicode(key)

    def set_auto_create_app(self, switch):
        switch = self._check_boolean(switch)
        self._request['AutoCreateApplication'] = misc.to_unicode(switch)

    def set_env_name(self, name):
        self._request['EnvironmentName'] = misc.to_unicode(name)

    def set_env_id(self, env_id):
        self._request['EnvironmentId'] = misc.to_unicode(env_id)
        
    def set_env_names(self, name_set):
        name_list = self._set_to_list(name_set)
        for i in range(len(name_list)):
            self._request['EnvironmentNames.member.' + misc.to_unicode(i + 1)] \
                = misc.to_unicode(name_list[i])

    def set_env_ids(self, id_set):
        id_list = self._set_to_list(id_set)
        for i in range(len(id_list)):
            self._request['EnvironmentIds.member.' + misc.to_unicode(i + 1)] \
                = misc.to_unicode(id_list[i])                

    def set_cname(self, name):
        self._request['CNAMEPrefix'] = misc.to_unicode(name)
        
    def set_source_configuration(self, name):
        self._request['SourceConfiguration'] = misc.to_unicode(name)
        
    def set_template(self, name):
        self._request['TemplateName'] = misc.to_unicode(name)
        
    def set_solution_stack(self, name):
        self._request['SolutionStackName'] = misc.to_unicode(name)

    def set_options(self, options_to_describe):
        index = 1
        for namespace, options in options_to_describe.items():
            for option_name in options:
                self._request['Options.member.' + misc.to_unicode(index) + '.Namespace'] \
                    = misc.to_unicode(namespace)
                self._request['Options.member.' + misc.to_unicode(index) + '.OptionName'] \
                    = misc.to_unicode(option_name)
                index = index + 1

    def set_option_settings(self, option_settings):
        index = 1
        for namespace, options in option_settings.items():
            for option_name, value in options.items():
                self._request['OptionSettings.member.' + misc.to_unicode(index) + '.Namespace'] \
                    = misc.to_unicode(namespace)
                self._request['OptionSettings.member.' + misc.to_unicode(index) + '.OptionName'] \
                    = misc.to_unicode(option_name)
                self._request['OptionSettings.member.' + misc.to_unicode(index) + '.Value'] \
                    = misc.to_unicode(value)
                index = index + 1

    def set_options_to_remove(self, options_to_remove):
        index = 1
        for namespace, options in options_to_remove.items():
            for option_name in options:
                self._request['OptionsToRemove.member.' + misc.to_unicode(index) + '.Namespace'] \
                    = misc.to_unicode(namespace)
                self._request['OptionsToRemove.member.' + misc.to_unicode(index) + '.OptionName'] \
                    = misc.to_unicode(option_name)
                index = index + 1

    def set_include_deleted(self, switch):
        switch = self._check_boolean(switch)
        self._request['IncludeDeleted'] = misc.to_unicode(switch)

    def set_included_deleted_backto(self, datetime):
        self._request['IncludedDeletedBackTo'] = misc.to_unicode(datetime)

    def set_start_time(self, datetime):
        self._request['StartTime'] = misc.to_unicode(datetime)

    def set_end_time(self, datetime):
        self._request['EndTime'] = misc.to_unicode(datetime)
        
    def set_max_records(self, num):
        self._request['MaxRecords'] = misc.to_unicode(num)
        
    def set_next_token(self, token):
        self._request['NextToken'] = misc.to_unicode(token)

    def set_requst_id(self, request_id):
        self._request['RequestId'] = misc.to_unicode(request_id)

    def set_severity(self, severity):
        self._request['Severity'] = misc.to_unicode(severity)
        
    def set_terminate_env(self, switch):
        self._request['TerminateEnvByForce'] = misc.to_unicode(switch)

    def set_delete_source_bundle(self, switch):
        self._request['DeleteSourceBundle'] = misc.to_unicode(switch)
        
    def set_terminate_resources(self, switch):
        self._request['TerminateResources'] = misc.to_unicode(switch)

    def set_template_specification(self, template_spec):
        #TemplateSource
        if template_spec.template_source is not None:
            ts = template_spec.template_source 
            if ts.solution_stack_name is not None:
                self._request['TemplateSpecification.TemplateSource.SolutionStackName'] \
                    = misc.to_unicode(ts.solution_stack_name)
                
        #Snippets
        if template_spec.template_snippets is not None:
            for i, snippet in enumerate(template_spec.template_snippets):
                if snippet.snippet_name is not None:
                    self._request['TemplateSpecification.TemplateSnippets.member.' \
                                  + misc.to_unicode(i + 1)+'.SnippetName'] \
                        = misc.to_unicode(snippet.snippet_name)
                if snippet.source_url is not None:
                    self._request['TemplateSpecification.TemplateSnippets.member.' \
                                  + misc.to_unicode(i + 1)+'.SourceUrl'] \
                        = misc.to_unicode(snippet.source_url)
                if snippet.order is not None:
                    self._request['TemplateSpecification.TemplateSnippets.member.' \
                                  + misc.to_unicode(i + 1)+'.Order'] \
                        = misc.to_unicode(snippet.order)

    def set_info_type(self, info_type):
        self._request['InfoType'] = misc.to_unicode(info_type)

        
class Response(object):
    
    def __init__(self, request_id, result = None, next_token = None):
        self._request_id = request_id
        self._result = result
        self._next_token = next_token
        
    def __repr__(self):
        return 'API Response.\n Request ID: {0}\n Results: {1}'.\
            format(self.request_id, misc.collection_to_string(self._result))
        
    @property
    def request_id(self):
        return self._request_id
    
    @property
    def result(self):
        return self._result
    
    @property
    def next_token(self):
        return self._next_token
    